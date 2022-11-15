# Action for [ideckia](https://ideckia.github.io/): color-picker

## Description

Pick the color from the point where the mouse is. The name shown is the closest color found in the DB [`colornames.json`](./colornames.json) file (taken from [here](https://www.npmjs.com/package/color-name-list)).

## Properties

| Name | Type | Description | Shared | Default | Possible values |
| ----- |----- | ----- | ----- | ----- | ----- |
| is_dynamic | Bool | Is the color updated constantly? | false | false | null |

## On single click

Pick the color from screen

## On long press

Change visualization mode: Color name, RGB, hexadecimal.

## Test the action

There is a script called `test_action.js` to test the new action. Set the `props` variable in the script with the properties you want and run this command:

```
node test_action.js
```

## Example in layout file

```json
{
    "text": "color-picker example",
    "bgColor": "00ff00",
    "actions": [
        {
            "name": "color-picker",
            "props": {
                "is_dynamic": false
            }
        }
    ]
}
```
