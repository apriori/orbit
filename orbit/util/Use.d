/**
 * Copyright: Copyright (c) 2010-2011 Jacob Carlborg.
 * Authors: Jacob Carlborg
 * Version: Initial created: Jan 29, 2010
 * License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost Software License 1.0)
 */
module orbit.util.Use;

version (Tango)
{
	import tango.core.Tuple;
	import tango.core.Traits;
}

else
{
	import std.typetuple;
	import std.traits;
	
	alias ReturnType ReturnTypeOf;
	alias ParameterTypeTuple ParameterTupleOf;
}


struct Use (ARGS...)
{
	static assert (ARGS.length > 0);
	
	private
	{
		alias ReturnTypeOf!(ARGS[0]) ReturnType;
		
		static if (ARGS.length >= 2)
			alias TypeTuple!(ReturnType delegate (ARGS), ARGS[1 .. $]) NEW_ARGS;
			
		else
			alias TypeTuple!(ReturnType delegate (ARGS)) NEW_ARGS;
	}
		
	NEW_ARGS args;
	
	ReturnType opIn (ARGS[0] dg)
	{
		assert(args[0]);
		
		static if (NEW_ARGS.length == 1)
			return args[0](dg);
			
		else
			return args[0](dg, args[1 .. $]);
	}
}

struct Restore (U, T)
{
	U delegate(U delegate (), ref T) dg; 
	T* value;
	
	U opIn (U delegate () deleg)
	{
		return dg(deleg, *value);
	}
}

Restore!(U, T) restore (U = void, T) (ref T val)
{
	Restore!(U, T) restoreStruct;
	
	restoreStruct.dg = (U delegate () dg, ref T value){
		T t = value;
		
		static if (is(U == void))
		{
			dg();
			value = t;
		}
		
		else
		{
			auto result = dg();
			value = t;
			
			return result;
		}
	};
	
	restoreStruct.value = &val;
	
	return restoreStruct;
}
