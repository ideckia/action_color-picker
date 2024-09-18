/*
const libnut = require("@nut-tree/libnut");
const nutjs = require("@nut-tree/nut-js");
// console.log(libnut.getMousePos())
nutjs.screen.colorAt(libnut.getMousePos()).then(c => console.log(c))

const capture = libnut.screen.capture();

const screenSize = libnut.getScreenSize();
const pixelDensity = {
    scaleX: capture.width / screenSize.width,
    scaleY: capture.height / screenSize.height,
};

const mousePos = libnut.getMousePos();
const scaledPointX = mousePos.x * pixelDensity.scaleX
const scaledPointY = mousePos.y * pixelDensity.scaleY;

const firstByte = capture.bytesPerPixel * (capture.width * scaledPointY + scaledPointX)

const buff = [];
for (let i = 0; i < capture.bytesPerPixel; i++) {
    buff.push(capture.image[firstByte + i]);
}

const color = {
    r: buff[2],
    g: buff[1],
    b: buff[0],
    a: buff[3],
}

console.log(color);
*/
const ac = require('.');
console.log(ac)

// put here the properties you want to test
const props = {};

const core = {
    log: {
        error: text => console.error(text),
        debug: text => console.debug(text),
        info: text => console.info(text)
    },
    dialog: {
        setDefaultOptions: (options) => console.log(options),
        notify: (title, _text) => console.log(title),
        info: (title, _text) => console.log(title),
        warning: (title, _text) => console.log(title),
        error: (title, _text) => console.log(title),
        question: (title, _text) => {
            console.log(title);
            return Promise.resolve(true);
        },
        selectFile: (title, _isDirectory = false, _multiple = false, _fileFilter = null) => {
            console.log(title);
            return Promise.resolve(['file0path', 'file1path']);
        },
        saveFile: (title, _saveName = null, _fileFilter = null) => {
            console.log(title);
            return Promise.resolve('filepath');
        },
        entry: (title, _text, _placeholder = null) => {
            console.log(title);
            return Promise.resolve('');
        },
        password: (title, _text, _username = false) => {
            console.log(title);
            return Promise.resolve(['username', 'password']);
        },
        progress: (title, _text, _pulsate = false, _autoClose = true) => {
            console.log(title);
            return {
                progress: (percentage) => console.log(`progress: ${percentage}`)
            };
        },
        color: (title, _initialColor = "#FFFFFF", _palette = false) => {
            console.log(title);
            return Promise.resolve({ red: 192, green: 192, blue: 192 });
        },
        calendar: (title, _text, _year = null, _month = null, _day = null, _dateFormat = null) => {
            console.log(title);
            return Promise.resolve(new Date().toString());
        },
        list: (title, _text, _columnHeader, _values, _multiple = false) => {
            console.log(title);
            return Promise.resolve(['item0', 'item1']);
        },
    },
    mediaPlayer: {
        play: (path) => {
            console.log(`Playing ${path} file.`);
            return 0;
        },
        pause: (id) => {
            console.log(`Pause ${id} media.`);
        },
        stop: (id) => {
            console.log(`Stop ${id} media.`);
        },
    },
    updateClientState: state => console.log('New state sent to the client: ' + state)
};

const action = new ac.IdeckiaAction();
action.setup(props, core);

const itemState = {
    text: 'State text',
    textSize: 15,
    textColor: '0x333333',
    icon: '',
    bgColor: '0x999999',
}
action.init(itemState);
action.execute(itemState)
    .then(responseState => console.log(responseState))
    .catch(error => console.error('Rejected: ' + error));