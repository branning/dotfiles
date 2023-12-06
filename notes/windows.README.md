# Remove carriage returns from text files

You can use tr to convert from DOS to Unix; however, you can only do this safely if CR appears in your file only as the first byte of a CRLF byte pair. This is usually the case. You then use:

    tr -d '\015' <DOS-file >UNIX-file
