# shelltools

A mix of things...

**zdiffwalk** walks through snapshots, showing you `zdiff` output.

    Usage: zdiffwalk dataset

    Once running, you can nagivate using:
      j  next pair
      k  previous pair
      l  display a list of snapshots
      g  go to a specific point in the list
      q  quit

**hashtest** tests hash values of files downloaded by `freebsd-update`
and deletes any files who fail their hash. Obviously, it requires root
privileges to delete anything. If run as !root, it will show warnings.

    Usage: hashtest

    (yes, that's it.)

