# shelltools

A mix of things...

**zdiffwalk** walks through snapshots, showing you `zfs diff` output.

    Usage: zdiffwalk dataset

    Once running, you can nagivate using:
      j  next pair
      k  previous pair
      l  display a list of snapshots
      g  go to a specific point in the list
      z  zoom
      q  quit

**cleanupdates** tests hash values of files downloaded by `freebsd-update`
and deletes any files who fail their hash. Obviously, it requires root
privileges to delete anything. If run as !root, it will show warnings.

    Usage: cleanupdates

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
	1 for the day before, etc. Assuming you're rotating logfiles daily.

**grab** fetches files from a remote server, perhaps safely.

	grab -h
	grab [-div] [user@]host:file ...

	For each file that grab copies, the target location is tested
	for permission and available space. If tests for any files fail,
	then no files are copied and temporary files are removed.

**dedup** deduplicates files with hard links

	dedup -h
	dedup [-nv] [dir/ ...]

	Deduplicates all files in given directories using hard links.
	File similarity is based on a hash calculated with b2sum or md5.
	Older files are hardlinked to newer files.

