package com.citrusengine.objects.persistance
{
	public final class PersistanceType
	{
		//Add Additional types of persistance,
		//Eg kForcesSaved or kRotationSaved to implement in
		//Persistance for checkpoint.Next will be 4, not 3
		public static const kNotSaved:uint = 0;
		public static const kExistSaved:uint = 1;
		public static const kPositionSaved:uint = 2;
	}
}