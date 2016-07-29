# WMutils shell scripts

List of included utilities and their usage:

- `clicker`
    - detects a mouse click and either (a) raises the window underneath the
      mouse, or (b) (TODO) raises a [patched dmenu][] as a menu if there is
      no window underneath the mouse.
- `fw`
    - **Focus Window**: Focuses a window.  Accepts arbitrarily long command
      chains as arguments.
- `{east,west,north,south}`
    - lists the windows in each direction (or more accurately, going in each
      direction) beginning from the current window.  Each accept command
      chains.
- `grandom`
    - sets the background to a random gradient.  FUN!
- `{incol,inrow}`
    - filters the window list to only include windows in the column or row
      of the current window.  Used with the directions, but I'm sure other
      possibilities exist.
- `irtw`
    - returns a point **In Regard To Window**.  Takes a corner (or 'md' for
      middle) and a window as arguments.
- `{next,prev}`
    - returns the next or previous window in the stack, accepting command
      chains to modify input.
- `wid`
    - a rip-off of [wildefyr's script][].
- `winfo`
    - return info of a window: name, class, pid, title for now.
- `wmwm`
    - event listener
- `wup`
    - return the **Window Under Point**.  Takes a point as input.

[patched dmenu]: https://github.com/duckwork/dmenu-duck
[wildefyr's script]: https://github.com/wildefyr/fyre/blob/master/wid

## Command chains

I keep talking about "command chains" here, though I don't really think that's
the best word for them.  Whatever.  The thinking is that instead of piping
things around all over the place (and having to worry about `pipefail` and all
that shiz), just do the ol' curry-type (maybe?) thing and give the functions as
arguments.  So that's what I've done with a lot of this.  TODO : even more so!

## Thanks

A big shout-out to wildefyr, z3bra, dcat, etc. w/ wmutils (oh, and venam
w/2bwm) for their hard work.  I looked off their papers a lot.

## Finally

This is a work in progress, so don't judge me.
