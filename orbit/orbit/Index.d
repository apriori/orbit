/**
 * Copyright: Copyright (c) 2011 Jacob Carlborg. All rights reserved.
 * Authors: Jacob Carlborg
 * Version: Initial created: Oct 8, 2011
 * License: $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost Software License 1.0)
 */
module orbit.orbit.Index;

import tango.io.device.File;

import orange.serialization._;
import orange.serialization.archives._;

import orbit.core._;
import Path = orbit.io.Path;
import orbit.orbit.Orb;
import orbit.orbit.Orbit;
import orbit.orbit.OrbVersion;
import orbit.orbit.Repository;

class Index
{
	const LocalRepository repository;
	
	private
	{
		const string path;
		
		Orb[OrbVersion][string] orbs_;
		XmlArchive!() archive;
		Serializer serializer;
	}
	
	this (LocalRepository repository)
	{
		this.repository = repository;
		this.path = repository.join(repository.source,
				repository.orbit.constants.index ~
				"." ~ repository.orbit.constants.indexFormat);
		
		archive = new XmlArchive!();
		serializer = new Serializer(archive);
	}
	
	void update (Orb orb)
	{
		if (!Path.exists(path))
			create(orb);
		
		else
		{
			load;
			auto orbs = orbs;
			orbs[orb.name][orb.version_] = orb;
		}
		
		write;
	}
	
	OrbVersion latestVersion (string name)
	{
		auto versions = orbs[name].keys;
		return versions.sort.last();
	}
	
	Orb opIndex (Orb orb)
	{
		return orbs[orb.name][orb.version_];
	}
	
private:
	
	Orb[OrbVersion][string] orbs ()
	{
		return orbs_ = isLoaded ? orbs_ : load;
	}
	
	Orb[OrbVersion][string] orbs (Orb[OrbVersion][string] orbs)
	{
		return orbs_ = orbs;
	}
	
	void create (Orb orb)
	{
		orbs = [orb.name : [orb.version_ : orb]];
	}
	
	void write ()
	{
		serializer.reset;
		auto index = serializer.serialize(orbs);
		File.set(path, index);
	}
	
	Orb[OrbVersion][string] load ()
	{
		return orbs = serializer.deserialize!(typeof(orbs_))(File.get(path));
	}
	
	bool isLoaded ()
	{
		return orbs !is null;
	}
	
	// Orb[OrbVersion] oldOrbs (Orb orb)
	// {
	// 	if (auto oldOrbs = orb.name in orbs)
	// 		return *oldOrbs;
	// 	
	// 	else
	// 		return [];
	// }
}