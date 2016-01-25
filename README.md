# shelltools

A mix of things...

**zdiffwalk** walks through snapshots, showing you `zdiff` output.

    Usage: zdiffwalk dataset

    Once running, you can nagivate using:
      j  next pair
      k  previous pair
      l  display a list of snapshots
      g  go to a specific point in the list
      z  zoom
      q  quit

**hashtest** tests hash values of files downloaded by `freebsd-update`
and deletes any files who fail their hash. Obviously, it requires root
privileges to delete anything. If run as !root, it will show warnings.

    Usage: hashtest

    (yes, that's it.)

**voicemailpasswordcheck** does basic sanity checking for Asterisk VM
password changes. Add or comment rules as you see fit. Pull requests
are welcome.

To use this, add the following to /etc/asterisk/voicemail.conf:

    [general]
    externpasscheck=/usr/local/bin/voicemailpasswordcheck

(or add to the section if it already exists.)  Then .. put the file
where you think it should go. :-)

**mailqgrep** helps you search through your Sendmail maillogs.

	Usage: mailqgrep [options] [daterange] searchstring

	where options are any of:
		-h	this help
		-d	include debug output (there isn't much of it)
		-p	pretty-print (indents et al)
		-q	quiet (not implemented)
		-v	verbose (show search string, default if on tty)

	and where daterange is blank for the current day, 0 for yesterday,
	1 for the day before, etc.

