/**
 * Copyright: Copyright (c) 2007-2008 Jacob Carlborg. All rights reserved.
 * Authors: Jacob Carlborg
 * Version: Initial created: 2007
 * License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost Software License 1.0)
 * 
 */
module orbit.core.io;

import tango.io.Stdout;

/**
 * Print to the standard output
 * 
 * Params:
 *     args = what to print
 */
void print (A...)(A args)
{
	enum string fmt = "{}{}{}{}{}{}{}{}"
			       	  "{}{}{}{}{}{}{}{}"
			       	  "{}{}{}{}{}{}{}{}";
			
	static assert (A.length <= fmt.length / 2, "mambo.io.print :: too many arguments");
	
	Stdout.format(fmt[0 .. args.length * 2], args).flush;
}

/**
 * Print to the standard output, adds a new line
 * 
 * Params:
 *     args = what to print
 */
void println (A...)(A args)
{
	enum string fmt = "{}{}{}{}{}{}{}{}"
		        	  "{}{}{}{}{}{}{}{}"
		        	  "{}{}{}{}{}{}{}{}";

	static assert (A.length <= fmt.length / 2, "mambo.io.println :: too many arguments");
	
	Stdout.formatln(fmt[0 .. args.length * 2], args);
}