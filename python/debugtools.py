def displayinvim(fullpath):
    """Open a file in Vim and move the cursor to the active line, if available.

    Meant to be called from pdb when there is a movement in the active line;
    sends a message to the vim process (which in this case acts like a server)
    calling its MoveToLine VimScript function.
    
    To see how this function is called you need to open the .pdbrc file where 
    a alias must exist to import this module and also call the function.

    Prints a message if no active line is found.

    Args:
        fullpath (str): The full path of the file to open in Vim.
    """
    linenum = getactiveline(fullpath)
    if linenum:
        import os
        cmd = f"""vim --remote-send "<esc>:call pdbnavigate#MoveToLine('{fullpath}', {linenum})<CR>"  """
        os.system(cmd)
    else:
        print("No active line was found..")


def reloadBreakpoints(fullpath):
    """Called when the user changes a breakpoint from the debuger.

    When the used adds or removes a breakpoint form the debuger, this
    function sends a message to the vim server to refresh the related display.
    """
    import os
    cmd = f"""vim --remote-send "<esc>:call pdbnavigate#RefreshBreakpoints('{fullpath}')<CR>"  """
    os.system(cmd)

def getactiveline(fullpath):
    """Get the line number of currently executing code in file.

    If file not found in traceback, returns `None`.
    
    Args:
        fullpath (str): Full path to the file to search for in the traceback.
        
    Returns:
        int or None: Line number of currently executing code in file,
                     or `None` if file is not found in the traceback.
    """
    import traceback
    lines = traceback.extract_stack()
    linenum = None
    for line in lines:
        try:
            fname, l = parseline(str(line))
            if fname.strip() == fullpath.strip():
                linenum = l
        except ValueError:
            pass
    return linenum


def parseline(line):
    """Parse a traceback line and return the filename and line number.

    Args:
        line (str): A string containing the traceback line to parse.

    Returns:
        tuple: A tuple containing the filename and line number as strings.

    Raises:
        ValueError: If the line cannot be parsed using the 
        expected regular expression.
    """   
    import re
    pattern = r'file\s(.*),\sline\s(\d+)\sin'
    match = re.search(pattern, line)
    if match:
        filename = match.group(1)
        line = match.group(2)
        return filename, int(line)
    raise ValueError

