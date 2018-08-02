# TaskVisualiser

Made in/with [Processing](https://processing.org/)

Compare multiple tasks and their durations
- Or use single-day tasks as markers for exciting upcoming events

Reads an input file written by the user, describing a task on each line.
Lines should be in the following format(without brackets and commas):

`[COURSE TITLE], [TASK NAME], ["from"], [DATE], ["to"], [DATE]`

Look at input.txt for an example

Write dates in the form DD/MM, with no year.

If you want to use the current day instead of a date, type "now"
- Useful when tasks are in progress - the visualisation will update daily, to show the task duration getting smaller
- Only works when no dates in the input file precede the current day

The colours are chosen randomly

The current day is highlighted in yellow

There is currently no error checking - the program assumes you have written the input file correctly
- Ensure there are no empty lines at the bottom of the input file
