extern crate image;
extern crate texture_packer;
extern crate glob;
extern crate serde_json;
extern crate serde;

use serde::{Serialize, Deserialize};
use glob::glob;
use std::fs::File;
use std::path::Path;
use texture_packer::{
    exporter::ImageExporter, importer::ImageImporter, texture::Texture,
    TexturePacker, TexturePackerConfig,
};
use std::io::Write;
use std::hash::Hash;
use image::{Rgba, imageops, DynamicImage};

#[derive(Serialize, Deserialize)]
struct Frame {
    k:String,
    x:u32,
    y:u32,
    w:u32,
    h:u32,
    sx:u32,
    sy:u32,
    sw:u32,
    sh:u32,
}

fn main() {

    // Config
    let config = TexturePackerConfig {
        max_width: 2048,
        max_height: 2048,
        allow_rotation: false,
        texture_outlines: false,
		texture_extrusion: 1,
        border_padding: 1,
        trim: true,
        ..Default::default()
    };

    // tiles
    let mut packer = TexturePacker::new_skyline(config);
    let filter = format!("../../assets_source/tiles/**/*.png");
    let mut ids = Vec::new();
    for path in glob(&filter).unwrap() {
        let path = path.unwrap();
        println!("{}", path.to_str().unwrap());
        
        let texture = ImageImporter::import_from_file(path.as_path()).unwrap();
        let name = path.strip_prefix("../../assets_source/tiles/").unwrap();
        let name_string = name.to_str().unwrap().to_string();
        
        ids.push(name_string.clone());

        packer.pack_own(name_string, texture).unwrap();
    }
    
    println!("Dimensions : {}x{}", packer.width(), packer.height());
    write("res/tiles/main", packer);

    // CoreTileId.hx
    ids.sort();
    let mut file = File::create("../../gen/game/gen/CoreTileId.hx").unwrap();
    let text = resolve_hx(&mut ids, "CoreTileId");
    write!(file, "{}", text).unwrap();
    file.flush().unwrap();
}


#[derive(Serialize, Deserialize)]
struct Point {
    x:u32,
    y:u32,
}


fn write<T:Clone + Texture<Pixel = Rgba<u8>>, P:Clone + Eq + Hash>(name:&str, packer:TexturePacker<T, P>) 
        where P: std::fmt::Display {
    let mut frames = Vec::new();
    for (_, frame) in packer.get_frames() {
        frames.push(
            Frame {
                k:frame.key.to_string(),
                x:frame.frame.x,
                y:frame.frame.y,
                w:frame.frame.w,
                h:frame.frame.h,
                sx:frame.source.x,
                sy:frame.source.y,
                sw:frame.source.w,
                sh:frame.source.h,
            }
        );
    }
    frames.sort_by(|x, y| x.k.cmp(&y.k));
    let json = serde_json::to_string(&frames).unwrap();
    let mut file = File::create(format!("../../{}.json", name)).unwrap();
    write!(file, "{}", json).unwrap();
    file.flush().unwrap();
    println!("{}", json);
    
    //
    // Save the result
    //
    let exporter = ImageExporter::export(&packer).unwrap();
    let mut result = DynamicImage::new_rgba8(next_2_power(exporter.width()), next_2_power(exporter.height()));
    imageops::overlay(&mut result, &exporter, 0, 0);
    let mut file = File::create(format!("../../{}.png", name)).unwrap();
    result
        .write_to(&mut file, image::ImageFormat::Png)
        .unwrap();

    println!("Output texture stored in {:?}", file);
}
fn next_2_power(value:u32) -> u32 {
    let mut result = 1;
    for _ in 0..31
    {
        if result >= value { return result }
        result <<= 1;
    }
    result
}

fn resolve_hx(contents:&Vec<String>, name:&str) -> String { 
    let mut body = String::new();
    for content in contents {
        let content = content.replace("/", "_").replace("\\", "_").replace(".png", "");
        let str = format!("    var {};\n", content.to_uppercase());
        body.push_str(&str);
    }
format!("package game.gen;
enum abstract {}(Int) {{
{}}}
", name, body)
}