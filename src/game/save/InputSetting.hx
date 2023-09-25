package game.save;

typedef InputSetting = {
    isPad:Bool,
    pad: {
        yellow   :String,
        blue     :String,
        yes      :String,
        no       :String,
        sub      :String,
        l    : String,
        r    : String,
        up   : String,
        down : String,
        left : String,
        right: String,
		pause: String,
		fullScreen: String,
		abReverse:Bool,
		xyReverse:Bool,
    },
    key: {
        yellow    : Int,
        blue      : Int,
        yes       : Int,
        no        : Int,
        sub       : Int,
        l         : Int,
        r         : Int,
        up        : Int,
        down      : Int,
        left      : Int,
        right     : Int,
		pause     : Int,
		fullScreen: Int,
    }
};
