/*----------------------------------------------------------------------------*-
                             ======================
                              YSI - Master Include
                             ======================
Description:
	Handles distribution of control of code segments across all running scripts
	with YSI to avoid conflicts of checkpoint streamers etc and allow features
	like "/commands" displaying all commands on the server.
	
	Now fully autonomous - to use the master system simply define which one you
	want and include the script:
	
	  #define MASTER 14
	  #include <YSI\Master>
	
	That will make the current script attempt to make itself the main master -
	you don't need ANY other code for initialisation anywhere (which took a
	while to figure out)...
	
	This is now over 2000 lines of repetitive and complex macros!
Legal:
	Version: MPL 1.1
	
	The contents of this file are subject to the Mozilla Public License Version 
	1.1 (the "License"); you may not use this file except in compliance with 
	the License. You may obtain a copy of the License at 
	http://www.mozilla.org/MPL/
	
	Software distributed under the License is distributed on an "AS IS" basis,
	WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
	for the specific language governing rights and limitations under the
	License.
	
	The Original Code is the SA:MP script information include.
	
	The Initial Developer of the Original Code is Alex "Y_Less" Cole.
	Portions created by the Initial Developer are Copyright (C) 2008
	the Initial Developer. All Rights Reserved.
	
	Contributors:
		ZeeX, koolk
	
	Thanks:
		Peter, Cam - Support.
		ZeeX - Very productive conversations.
		koolk - IsPlayerinAreaEx code.
		TheAlpha - Danish translation.
		breadfish - German translation.
		Fireburn - Dutch translation.
		yom - French translation.
		50p - Polish translation.
		Zamaroht - Spanish translation.
		Dracoblue, sintax, mabako, Xtreme, other coders - Producing other modes
			for me to strive to better.
		Pixels^ - Running XScripters where the idea was born.
		Matite - Pestering me to release it and using it.
	
	Very special thanks to:
		Thiadmer - PAWN.
		Kye/Kalcor - SA:MP.
		SA:MP Team past, present and future - SA:MP.
Version:
	0.2
Changelog:
	06/08/10:
		Managed the ultimate - got completely transparent inclusion!
	05/08/10:
		Completed new master system, now does all syncing and clients.
	06/10/09:
		Rewrote using states.
		Added remote function macros.
		Reduced the number of masters to a single one.  It must have them all.
		Vastly simplified the master model - ending the master ends everything.
	06/01/08:
		Added code to not pass data if no other script exists.
	17/11/07:
		Added code for a script to remove itself from the global list.
	11/10/07:
		Not first version but added documentation months late.
Functions:
	Public:
		-
	Core:
		-
	Stock:
		-
	Static:
		-
	Inline:
		-
	API:
		-
	Hooks:
		-
Callbacks:
	-
Definitions:
	-
Enums:
	-
Macros:
	RF - Declare a function which may be remote.
	RV - Declare a void function which may be remote.
	RS - Declare an optional callback.
	RFN - Declare an optional callback with no parameters.
	RFC - Declare a slower but shorter function.
	RFP - Declare a function with tags and give recall hints.
	RFPC - Combination of P and C.
	RFCP - Combination of P and C.
Tags:
	-
Variables:
	Global:
		_@ - ID of this script.
	Static:
		-
Commands:
	-
Compile options:
	YSI_NO_MASTER - Don't use the master system.
	YSI_IS_CLIENT - Script is a client only script.
	YSI_IS_SERVER - Script is a server only script.
Operators:
	-
Natives:
	-
-*----------------------------------------------------------------------------*/

// ALWAYS!  The compiler defines this automatically, don't use it as this is
// included multiple times to handle multiple master systems.
#undef _inc_y_master

#if !defined MASTER
	#tryinclude <YSI\internal\y_automasters>
	#if !defined MASTER
		//#error "You must define a unique MASTER number from 0 to 25."
		// Default for user scripts.
		#define MASTER 0
	#endif
#endif

#if MASTER > 25 || MASTER < 0
	// There are some secret ones reserved purely for YSI!
	//#if !defined _YSIM_USED_AUTO || MASTER > 42
		#error "Invalid MASTER value, must be between 0 and 25 (inclusive)."
	//#endif
#endif

#if defined YSIM_HAS_MASTER
	#undef YSIM_HAS_MASTER
#endif

#if defined YSIM_IS_CLIENT
	#undef YSIM_IS_CLIENT
#endif

#if defined YSIM_IS_SERVER
	#undef YSIM_IS_SERVER
#endif

#if defined YSIM_CLOUD
	#undef YSIM_CLOUD
#endif

//#if defined YSIM_NOT_CLIENT
//	#undef YSIM_NOT_CLIENT
//#endif

#if defined _YSIM_OVERRIDE
	// Get stored settings for YSI libraries.  This allows the group system to
	// use the same master settings as another library without being there at
	// the time.
	#if YSIM_STORED_SETTINGS & 1
		#define YSIM_HAS_MASTER 1
	#else
		#define YSIM_HAS_MASTER 0
	#endif
	
	#if YSIM_STORED_SETTINGS & 2
		#define YSIM_IS_CLIENT 1
	#else
		#define YSIM_IS_CLIENT 0
	#endif
	
	#if YSIM_STORED_SETTINGS & 4
		#define YSIM_IS_SERVER 1
	#else
		#define YSIM_IS_SERVER 0
	#endif
	
	#if YSIM_STORED_SETTINGS & 8
		#define YSIM_CLOUD 1
	#else
		#define YSIM_CLOUD 0
	#endif
#else
	// Set up simple quick macros to query different current capabilities.
	#if (!defined YSI_NO_MASTER || defined YSIM_T_ENABLE) && !defined YSIM_T_DISABLE
		#define YSIM_HAS_MASTER 1
	#else
		#define YSIM_HAS_MASTER 0
	#endif
	
	#if (defined YSI_IS_CLIENT || defined YSIM_C_ENABLE) && !defined YSIM_C_DISABLE
		#define YSIM_IS_CLIENT 1
	#else
		#define YSIM_IS_CLIENT 0
	#endif
	
	#if (defined YSI_IS_SERVER || defined YSIM_S_ENABLE) && !defined YSIM_S_DISABLE
		#define YSIM_IS_SERVER 1
	#else
		#define YSIM_IS_SERVER 0
	#endif
	
	#if YSIM_HAS_MASTER && !YSIM_IS_CLIENT && !YSIM_IS_SERVER
		#define YSIM_CLOUD 1
	#else
		#define YSIM_CLOUD 0
	#endif
#endif

#if defined _inc_y_masteronce

// Been included at least once, clean up from before.
#undef RF
#undef RF@p
#undef RF@c
#undef RF@v
//#undef RF@n
#undef RF@pc
#undef RF@pv
#undef RF@pcv
#undef RF@vc
//#undef RF@vn

#undef RC

#undef RH
//#undef RC@v
//#undef RC@n
//#undef RC@vn

#undef Master_Caller
//#undef Master_Init

#endif

#include <YSI\y_utils>

#include <YSI\internal\y_masteronce>

// Clear up some artifacts
#if defined YSIM_DEFINED
	#undef YSIM_DEFINED
#endif

#if defined _YCM
	#undef _YCM
#endif

// Now set the current script data.
#if MASTER == 0
	#if defined _YCM_a@
		#define YSIM_DEFINED
	#else
		#define _YCM_a@
		// Save the settings.
		#if YSIM_HAS_MASTER
			#if YSIM_IS_CLIENT
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_0 15
					#else
						#define YSIM_RECALL_0 7
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_0 11
					#else
						#define YSIM_RECALL_0 3
					#endif
				#endif
			#else
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_0 13
					#else
						#define YSIM_RECALL_0 5
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_0 9
					#else
						#define YSIM_RECALL_0 1
					#endif
				#endif
			#endif
		#else
			#if YSIM_IS_CLIENT
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_0 14
					#else
						#define YSIM_RECALL_0 6
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_0 10
					#else
						#define YSIM_RECALL_0 2
					#endif
				#endif
			#else
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_0 12
					#else
						#define YSIM_RECALL_0 4
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_0 8
					#else
						#define YSIM_RECALL_0 0
					#endif
				#endif
			#endif
		#endif
	#endif
	#define _YCM a@
#endif
#if MASTER == 1
	#if defined _YCM_b@
		#define YSIM_DEFINED
	#else
		#define _YCM_b@
		// Save the settings.
		#if YSIM_HAS_MASTER
			#if YSIM_IS_CLIENT
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_1 15
					#else
						#define YSIM_RECALL_1 7
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_1 11
					#else
						#define YSIM_RECALL_1 3
					#endif
				#endif
			#else
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_1 13
					#else
						#define YSIM_RECALL_1 5
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_1 9
					#else
						#define YSIM_RECALL_1 1
					#endif
				#endif
			#endif
		#else
			#if YSIM_IS_CLIENT
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_1 14
					#else
						#define YSIM_RECALL_1 6
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_1 10
					#else
						#define YSIM_RECALL_1 2
					#endif
				#endif
			#else
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_1 12
					#else
						#define YSIM_RECALL_1 4
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_1 8
					#else
						#define YSIM_RECALL_1 0
					#endif
				#endif
			#endif
		#endif
	#endif
	#define _YCM b@
#endif
#if MASTER == 2
	#if defined _YCM_c@
		#define YSIM_DEFINED
	#else
		#define _YCM_c@
		// Save the settings.
		#if YSIM_HAS_MASTER
			#if YSIM_IS_CLIENT
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_2 15
					#else
						#define YSIM_RECALL_2 7
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_2 11
					#else
						#define YSIM_RECALL_2 3
					#endif
				#endif
			#else
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_2 13
					#else
						#define YSIM_RECALL_2 5
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_2 9
					#else
						#define YSIM_RECALL_2 1
					#endif
				#endif
			#endif
		#else
			#if YSIM_IS_CLIENT
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_2 14
					#else
						#define YSIM_RECALL_2 6
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_2 10
					#else
						#define YSIM_RECALL_2 2
					#endif
				#endif
			#else
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_2 12
					#else
						#define YSIM_RECALL_2 4
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_2 8
					#else
						#define YSIM_RECALL_2 0
					#endif
				#endif
			#endif
		#endif
	#endif
	#define _YCM c@
#endif
#if MASTER == 3
	#if defined _YCM_d@
		#define YSIM_DEFINED
	#else
		#define _YCM_d@
		// Save the settings.
		#if YSIM_HAS_MASTER
			#if YSIM_IS_CLIENT
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_3 15
					#else
						#define YSIM_RECALL_3 7
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_3 11
					#else
						#define YSIM_RECALL_3 3
					#endif
				#endif
			#else
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_3 13
					#else
						#define YSIM_RECALL_3 5
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_3 9
					#else
						#define YSIM_RECALL_3 1
					#endif
				#endif
			#endif
		#else
			#if YSIM_IS_CLIENT
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_3 14
					#else
						#define YSIM_RECALL_3 6
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_3 10
					#else
						#define YSIM_RECALL_3 2
					#endif
				#endif
			#else
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_3 12
					#else
						#define YSIM_RECALL_3 4
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_3 8
					#else
						#define YSIM_RECALL_3 0
					#endif
				#endif
			#endif
		#endif
	#endif
	#define _YCM d@
#endif
#if MASTER == 4
	#if defined _YCM_e@
		#define YSIM_DEFINED
	#else
		#define _YCM_e@
		// Save the settings.
		#if YSIM_HAS_MASTER
			#if YSIM_IS_CLIENT
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_4 15
					#else
						#define YSIM_RECALL_4 7
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_4 11
					#else
						#define YSIM_RECALL_4 3
					#endif
				#endif
			#else
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_4 13
					#else
						#define YSIM_RECALL_4 5
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_4 9
					#else
						#define YSIM_RECALL_4 1
					#endif
				#endif
			#endif
		#else
			#if YSIM_IS_CLIENT
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_4 14
					#else
						#define YSIM_RECALL_4 6
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_4 10
					#else
						#define YSIM_RECALL_4 2
					#endif
				#endif
			#else
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_4 12
					#else
						#define YSIM_RECALL_4 4
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_4 8
					#else
						#define YSIM_RECALL_4 0
					#endif
				#endif
			#endif
		#endif
	#endif
	#define _YCM e@
#endif
#if MASTER == 5
	#if defined _YCM_f@
		#define YSIM_DEFINED
	#else
		#define _YCM_f@
		// Save the settings.
		#if YSIM_HAS_MASTER
			#if YSIM_IS_CLIENT
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_5 15
					#else
						#define YSIM_RECALL_5 7
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_5 11
					#else
						#define YSIM_RECALL_5 3
					#endif
				#endif
			#else
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_5 13
					#else
						#define YSIM_RECALL_5 5
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_5 9
					#else
						#define YSIM_RECALL_5 1
					#endif
				#endif
			#endif
		#else
			#if YSIM_IS_CLIENT
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_5 14
					#else
						#define YSIM_RECALL_5 6
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_5 10
					#else
						#define YSIM_RECALL_5 2
					#endif
				#endif
			#else
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_5 12
					#else
						#define YSIM_RECALL_5 4
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_5 8
					#else
						#define YSIM_RECALL_5 0
					#endif
				#endif
			#endif
		#endif
	#endif
	#define _YCM f@
#endif
#if MASTER == 6
	#if defined _YCM_g@
		#define YSIM_DEFINED
	#else
		#define _YCM_g@
		// Save the settings.
		#if YSIM_HAS_MASTER
			#if YSIM_IS_CLIENT
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_6 15
					#else
						#define YSIM_RECALL_6 7
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_6 11
					#else
						#define YSIM_RECALL_6 3
					#endif
				#endif
			#else
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_6 13
					#else
						#define YSIM_RECALL_6 5
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_6 9
					#else
						#define YSIM_RECALL_6 1
					#endif
				#endif
			#endif
		#else
			#if YSIM_IS_CLIENT
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_6 14
					#else
						#define YSIM_RECALL_6 6
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_6 10
					#else
						#define YSIM_RECALL_6 2
					#endif
				#endif
			#else
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_6 12
					#else
						#define YSIM_RECALL_6 4
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_6 8
					#else
						#define YSIM_RECALL_6 0
					#endif
				#endif
			#endif
		#endif
	#endif
	#define _YCM g@
#endif
#if MASTER == 7
	#if defined _YCM_h@
		#define YSIM_DEFINED
	#else
		#define _YCM_h@
		// Save the settings.
		#if YSIM_HAS_MASTER
			#if YSIM_IS_CLIENT
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_7 15
					#else
						#define YSIM_RECALL_7 7
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_7 11
					#else
						#define YSIM_RECALL_7 3
					#endif
				#endif
			#else
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_7 13
					#else
						#define YSIM_RECALL_7 5
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_7 9
					#else
						#define YSIM_RECALL_7 1
					#endif
				#endif
			#endif
		#else
			#if YSIM_IS_CLIENT
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_7 14
					#else
						#define YSIM_RECALL_7 6
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_7 10
					#else
						#define YSIM_RECALL_7 2
					#endif
				#endif
			#else
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_7 12
					#else
						#define YSIM_RECALL_7 4
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_7 8
					#else
						#define YSIM_RECALL_7 0
					#endif
				#endif
			#endif
		#endif
	#endif
	#define _YCM h@
#endif
#if MASTER == 8
	#if defined _YCM_i@
		#define YSIM_DEFINED
	#else
		#define _YCM_i@
		// Save the settings.
		#if YSIM_HAS_MASTER
			#if YSIM_IS_CLIENT
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_8 15
					#else
						#define YSIM_RECALL_8 7
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_8 11
					#else
						#define YSIM_RECALL_8 3
					#endif
				#endif
			#else
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_8 13
					#else
						#define YSIM_RECALL_8 5
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_8 9
					#else
						#define YSIM_RECALL_8 1
					#endif
				#endif
			#endif
		#else
			#if YSIM_IS_CLIENT
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_8 14
					#else
						#define YSIM_RECALL_8 6
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_8 10
					#else
						#define YSIM_RECALL_8 2
					#endif
				#endif
			#else
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_8 12
					#else
						#define YSIM_RECALL_8 4
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_8 8
					#else
						#define YSIM_RECALL_8 0
					#endif
				#endif
			#endif
		#endif
	#endif
	#define _YCM i@
#endif
#if MASTER == 9
	#if defined _YCM_j@
		#define YSIM_DEFINED
	#else
		#define _YCM_j@
		// Save the settings.
		#if YSIM_HAS_MASTER
			#if YSIM_IS_CLIENT
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_9 15
					#else
						#define YSIM_RECALL_9 7
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_9 11
					#else
						#define YSIM_RECALL_9 3
					#endif
				#endif
			#else
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_9 13
					#else
						#define YSIM_RECALL_9 5
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_9 9
					#else
						#define YSIM_RECALL_9 1
					#endif
				#endif
			#endif
		#else
			#if YSIM_IS_CLIENT
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_9 14
					#else
						#define YSIM_RECALL_9 6
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_9 10
					#else
						#define YSIM_RECALL_9 2
					#endif
				#endif
			#else
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_9 12
					#else
						#define YSIM_RECALL_9 4
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_9 8
					#else
						#define YSIM_RECALL_9 0
					#endif
				#endif
			#endif
		#endif
	#endif
	#define _YCM j@
#endif
#if MASTER == 10
	#if defined _YCM_k@
		#define YSIM_DEFINED
	#else
		#define _YCM_k@
		// Save the settings.
		#if YSIM_HAS_MASTER
			#if YSIM_IS_CLIENT
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_10 15
					#else
						#define YSIM_RECALL_10 7
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_10 11
					#else
						#define YSIM_RECALL_10 3
					#endif
				#endif
			#else
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_10 13
					#else
						#define YSIM_RECALL_10 5
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_10 9
					#else
						#define YSIM_RECALL_10 1
					#endif
				#endif
			#endif
		#else
			#if YSIM_IS_CLIENT
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_10 14
					#else
						#define YSIM_RECALL_10 6
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_10 10
					#else
						#define YSIM_RECALL_10 2
					#endif
				#endif
			#else
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_10 12
					#else
						#define YSIM_RECALL_10 4
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_10 8
					#else
						#define YSIM_RECALL_10 0
					#endif
				#endif
			#endif
		#endif
	#endif
	#define _YCM k@
#endif
#if MASTER == 11
	#if defined _YCM_l@
		#define YSIM_DEFINED
	#else
		#define _YCM_l@
		// Save the settings.
		#if YSIM_HAS_MASTER
			#if YSIM_IS_CLIENT
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_11 15
					#else
						#define YSIM_RECALL_11 7
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_11 11
					#else
						#define YSIM_RECALL_11 3
					#endif
				#endif
			#else
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_11 13
					#else
						#define YSIM_RECALL_11 5
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_11 9
					#else
						#define YSIM_RECALL_11 1
					#endif
				#endif
			#endif
		#else
			#if YSIM_IS_CLIENT
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_11 14
					#else
						#define YSIM_RECALL_11 6
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_11 10
					#else
						#define YSIM_RECALL_11 2
					#endif
				#endif
			#else
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_11 12
					#else
						#define YSIM_RECALL_11 4
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_11 8
					#else
						#define YSIM_RECALL_11 0
					#endif
				#endif
			#endif
		#endif
	#endif
	#define _YCM l@
#endif
#if MASTER == 12
	#if defined _YCM_m@
		#define YSIM_DEFINED
	#else
		#define _YCM_m@
		// Save the settings.
		#if YSIM_HAS_MASTER
			#if YSIM_IS_CLIENT
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_12 15
					#else
						#define YSIM_RECALL_12 7
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_12 11
					#else
						#define YSIM_RECALL_12 3
					#endif
				#endif
			#else
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_12 13
					#else
						#define YSIM_RECALL_12 5
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_12 9
					#else
						#define YSIM_RECALL_12 1
					#endif
				#endif
			#endif
		#else
			#if YSIM_IS_CLIENT
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_12 14
					#else
						#define YSIM_RECALL_12 6
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_12 10
					#else
						#define YSIM_RECALL_12 2
					#endif
				#endif
			#else
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_12 12
					#else
						#define YSIM_RECALL_12 4
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_12 8
					#else
						#define YSIM_RECALL_12 0
					#endif
				#endif
			#endif
		#endif
	#endif
	#define _YCM m@
#endif
#if MASTER == 13
	#if defined _YCM_n@
		#define YSIM_DEFINED
	#else
		#define _YCM_n@
		// Save the settings.
		#if YSIM_HAS_MASTER
			#if YSIM_IS_CLIENT
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_13 15
					#else
						#define YSIM_RECALL_13 7
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_13 11
					#else
						#define YSIM_RECALL_13 3
					#endif
				#endif
			#else
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_13 13
					#else
						#define YSIM_RECALL_13 5
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_13 9
					#else
						#define YSIM_RECALL_13 1
					#endif
				#endif
			#endif
		#else
			#if YSIM_IS_CLIENT
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_13 14
					#else
						#define YSIM_RECALL_13 6
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_13 10
					#else
						#define YSIM_RECALL_13 2
					#endif
				#endif
			#else
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_13 12
					#else
						#define YSIM_RECALL_13 4
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_13 8
					#else
						#define YSIM_RECALL_13 0
					#endif
				#endif
			#endif
		#endif
	#endif
	#define _YCM n@
#endif
#if MASTER == 14
	#if defined _YCM_o@
		#define YSIM_DEFINED
	#else
		#define _YCM_o@
		// Save the settings.
		#if YSIM_HAS_MASTER
			#if YSIM_IS_CLIENT
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_14 15
					#else
						#define YSIM_RECALL_14 7
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_14 11
					#else
						#define YSIM_RECALL_14 3
					#endif
				#endif
			#else
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_14 13
					#else
						#define YSIM_RECALL_14 5
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_14 9
					#else
						#define YSIM_RECALL_14 1
					#endif
				#endif
			#endif
		#else
			#if YSIM_IS_CLIENT
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_14 14
					#else
						#define YSIM_RECALL_14 6
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_14 10
					#else
						#define YSIM_RECALL_14 2
					#endif
				#endif
			#else
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_14 12
					#else
						#define YSIM_RECALL_14 4
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_14 8
					#else
						#define YSIM_RECALL_14 0
					#endif
				#endif
			#endif
		#endif
	#endif
	#define _YCM o@
#endif
#if MASTER == 15
	#if defined _YCM_p@
		#define YSIM_DEFINED
	#else
		#define _YCM_p@
		// Save the settings.
		#if YSIM_HAS_MASTER
			#if YSIM_IS_CLIENT
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_15 15
					#else
						#define YSIM_RECALL_15 7
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_15 11
					#else
						#define YSIM_RECALL_15 3
					#endif
				#endif
			#else
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_15 13
					#else
						#define YSIM_RECALL_15 5
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_15 9
					#else
						#define YSIM_RECALL_15 1
					#endif
				#endif
			#endif
		#else
			#if YSIM_IS_CLIENT
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_15 14
					#else
						#define YSIM_RECALL_15 6
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_15 10
					#else
						#define YSIM_RECALL_15 2
					#endif
				#endif
			#else
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_15 12
					#else
						#define YSIM_RECALL_15 4
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_15 8
					#else
						#define YSIM_RECALL_15 0
					#endif
				#endif
			#endif
		#endif
	#endif
	#define _YCM p@
#endif
#if MASTER == 16
	#if defined _YCM_q@
		#define YSIM_DEFINED
	#else
		#define _YCM_q@
		// Save the settings.
		#if YSIM_HAS_MASTER
			#if YSIM_IS_CLIENT
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_16 15
					#else
						#define YSIM_RECALL_16 7
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_16 11
					#else
						#define YSIM_RECALL_16 3
					#endif
				#endif
			#else
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_16 13
					#else
						#define YSIM_RECALL_16 5
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_16 9
					#else
						#define YSIM_RECALL_16 1
					#endif
				#endif
			#endif
		#else
			#if YSIM_IS_CLIENT
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_16 14
					#else
						#define YSIM_RECALL_16 6
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_16 10
					#else
						#define YSIM_RECALL_16 2
					#endif
				#endif
			#else
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_16 12
					#else
						#define YSIM_RECALL_16 4
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_16 8
					#else
						#define YSIM_RECALL_16 0
					#endif
				#endif
			#endif
		#endif
	#endif
	#define _YCM q@
#endif
#if MASTER == 17
	#if defined _YCM_r@
		#define YSIM_DEFINED
	#else
		#define _YCM_r@
		// Save the settings.
		#if YSIM_HAS_MASTER
			#if YSIM_IS_CLIENT
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_17 15
					#else
						#define YSIM_RECALL_17 7
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_17 11
					#else
						#define YSIM_RECALL_17 3
					#endif
				#endif
			#else
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_17 13
					#else
						#define YSIM_RECALL_17 5
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_17 9
					#else
						#define YSIM_RECALL_17 1
					#endif
				#endif
			#endif
		#else
			#if YSIM_IS_CLIENT
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_17 14
					#else
						#define YSIM_RECALL_17 6
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_17 10
					#else
						#define YSIM_RECALL_17 2
					#endif
				#endif
			#else
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_17 12
					#else
						#define YSIM_RECALL_17 4
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_17 8
					#else
						#define YSIM_RECALL_17 0
					#endif
				#endif
			#endif
		#endif
	#endif
	#define _YCM r@
#endif
#if MASTER == 18
	#if defined _YCM_s@
		#define YSIM_DEFINED
	#else
		#define _YCM_s@
		// Save the settings.
		#if YSIM_HAS_MASTER
			#if YSIM_IS_CLIENT
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_18 15
					#else
						#define YSIM_RECALL_18 7
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_18 11
					#else
						#define YSIM_RECALL_18 3
					#endif
				#endif
			#else
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_18 13
					#else
						#define YSIM_RECALL_18 5
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_18 9
					#else
						#define YSIM_RECALL_18 1
					#endif
				#endif
			#endif
		#else
			#if YSIM_IS_CLIENT
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_18 14
					#else
						#define YSIM_RECALL_18 6
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_18 10
					#else
						#define YSIM_RECALL_18 2
					#endif
				#endif
			#else
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_18 12
					#else
						#define YSIM_RECALL_18 4
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_18 8
					#else
						#define YSIM_RECALL_18 0
					#endif
				#endif
			#endif
		#endif
	#endif
	#define _YCM s@
#endif
#if MASTER == 19
	#if defined _YCM_t@
		#define YSIM_DEFINED
	#else
		#define _YCM_t@
		// Save the settings.
		#if YSIM_HAS_MASTER
			#if YSIM_IS_CLIENT
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_19 15
					#else
						#define YSIM_RECALL_19 7
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_19 11
					#else
						#define YSIM_RECALL_19 3
					#endif
				#endif
			#else
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_19 13
					#else
						#define YSIM_RECALL_19 5
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_19 9
					#else
						#define YSIM_RECALL_19 1
					#endif
				#endif
			#endif
		#else
			#if YSIM_IS_CLIENT
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_19 14
					#else
						#define YSIM_RECALL_19 6
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_19 10
					#else
						#define YSIM_RECALL_19 2
					#endif
				#endif
			#else
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_19 12
					#else
						#define YSIM_RECALL_19 4
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_19 8
					#else
						#define YSIM_RECALL_19 0
					#endif
				#endif
			#endif
		#endif
	#endif
	#define _YCM t@
#endif
#if MASTER == 20
	#if defined _YCM_u@
		#define YSIM_DEFINED
	#else
		#define _YCM_u@
		// Save the settings.
		#if YSIM_HAS_MASTER
			#if YSIM_IS_CLIENT
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_20 15
					#else
						#define YSIM_RECALL_20 7
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_20 11
					#else
						#define YSIM_RECALL_20 3
					#endif
				#endif
			#else
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_20 13
					#else
						#define YSIM_RECALL_20 5
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_20 9
					#else
						#define YSIM_RECALL_20 1
					#endif
				#endif
			#endif
		#else
			#if YSIM_IS_CLIENT
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_20 14
					#else
						#define YSIM_RECALL_20 6
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_20 10
					#else
						#define YSIM_RECALL_20 2
					#endif
				#endif
			#else
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_20 12
					#else
						#define YSIM_RECALL_20 4
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_20 8
					#else
						#define YSIM_RECALL_20 0
					#endif
				#endif
			#endif
		#endif
	#endif
	#define _YCM u@
#endif
#if MASTER == 21
	#if defined _YCM_v@
		#define YSIM_DEFINED
	#else
		#define _YCM_v@
		// Save the settings.
		#if YSIM_HAS_MASTER
			#if YSIM_IS_CLIENT
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_21 15
					#else
						#define YSIM_RECALL_21 7
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_21 11
					#else
						#define YSIM_RECALL_21 3
					#endif
				#endif
			#else
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_21 13
					#else
						#define YSIM_RECALL_21 5
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_21 9
					#else
						#define YSIM_RECALL_21 1
					#endif
				#endif
			#endif
		#else
			#if YSIM_IS_CLIENT
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_21 14
					#else
						#define YSIM_RECALL_21 6
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_21 10
					#else
						#define YSIM_RECALL_21 2
					#endif
				#endif
			#else
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_21 12
					#else
						#define YSIM_RECALL_21 4
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_21 8
					#else
						#define YSIM_RECALL_21 0
					#endif
				#endif
			#endif
		#endif
	#endif
	#define _YCM v@
#endif
#if MASTER == 22
	#if defined _YCM_w@
		#define YSIM_DEFINED
	#else
		#define _YCM_w@
		// Save the settings.
		#if YSIM_HAS_MASTER
			#if YSIM_IS_CLIENT
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_22 15
					#else
						#define YSIM_RECALL_22 7
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_22 11
					#else
						#define YSIM_RECALL_22 3
					#endif
				#endif
			#else
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_22 13
					#else
						#define YSIM_RECALL_22 5
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_22 9
					#else
						#define YSIM_RECALL_22 1
					#endif
				#endif
			#endif
		#else
			#if YSIM_IS_CLIENT
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_22 14
					#else
						#define YSIM_RECALL_22 6
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_22 10
					#else
						#define YSIM_RECALL_22 2
					#endif
				#endif
			#else
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_22 12
					#else
						#define YSIM_RECALL_22 4
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_22 8
					#else
						#define YSIM_RECALL_22 0
					#endif
				#endif
			#endif
		#endif
	#endif
	#define _YCM w@
#endif
#if MASTER == 23
	#if defined _YCM_x@
		#define YSIM_DEFINED
	#else
		#define _YCM_x@
		// Save the settings.
		#if YSIM_HAS_MASTER
			#if YSIM_IS_CLIENT
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_23 15
					#else
						#define YSIM_RECALL_23 7
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_23 11
					#else
						#define YSIM_RECALL_23 3
					#endif
				#endif
			#else
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_23 13
					#else
						#define YSIM_RECALL_23 5
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_23 9
					#else
						#define YSIM_RECALL_23 1
					#endif
				#endif
			#endif
		#else
			#if YSIM_IS_CLIENT
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_23 14
					#else
						#define YSIM_RECALL_23 6
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_23 10
					#else
						#define YSIM_RECALL_23 2
					#endif
				#endif
			#else
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_23 12
					#else
						#define YSIM_RECALL_23 4
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_23 8
					#else
						#define YSIM_RECALL_23 0
					#endif
				#endif
			#endif
		#endif
	#endif
	#define _YCM x@
#endif
#if MASTER == 24
	#if defined _YCM_y@
		#define YSIM_DEFINED
	#else
		#define _YCM_y@
		// Save the settings.
		#if YSIM_HAS_MASTER
			#if YSIM_IS_CLIENT
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_24 15
					#else
						#define YSIM_RECALL_24 7
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_24 11
					#else
						#define YSIM_RECALL_24 3
					#endif
				#endif
			#else
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_24 13
					#else
						#define YSIM_RECALL_24 5
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_24 9
					#else
						#define YSIM_RECALL_24 1
					#endif
				#endif
			#endif
		#else
			#if YSIM_IS_CLIENT
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_24 14
					#else
						#define YSIM_RECALL_24 6
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_24 10
					#else
						#define YSIM_RECALL_24 2
					#endif
				#endif
			#else
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_24 12
					#else
						#define YSIM_RECALL_24 4
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_24 8
					#else
						#define YSIM_RECALL_24 0
					#endif
				#endif
			#endif
		#endif
	#endif
	#define _YCM y@
#endif
#if MASTER == 25
	#if defined _YCM_z@
		#define YSIM_DEFINED
	#else
		#define _YCM_z@
		// Save the settings.
		#if YSIM_HAS_MASTER
			#if YSIM_IS_CLIENT
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_25 15
					#else
						#define YSIM_RECALL_25 7
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_25 11
					#else
						#define YSIM_RECALL_25 3
					#endif
				#endif
			#else
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_25 13
					#else
						#define YSIM_RECALL_25 5
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_25 9
					#else
						#define YSIM_RECALL_25 1
					#endif
				#endif
			#endif
		#else
			#if YSIM_IS_CLIENT
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_25 14
					#else
						#define YSIM_RECALL_25 6
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_25 10
					#else
						#define YSIM_RECALL_25 2
					#endif
				#endif
			#else
				#if YSIM_IS_SERVER
					#if YSIM_CLOUD
						#define YSIM_RECALL_25 12
					#else
						#define YSIM_RECALL_25 4
					#endif
				#else
					#if YSIM_CLOUD
						#define YSIM_RECALL_25 8
					#else
						#define YSIM_RECALL_25 0
					#endif
				#endif
			#endif
		#endif
	#endif
	#define _YCM z@
#endif

// Check for non-unique masters here.
#if defined YSIM_DEFINED && !defined _YSIM_OVERRIDE
	#error "Non-unique master used."
#endif

#if YSIM_NOT_CLIENT && !defined YSIM_DEFINED
	// FIRST declare the next callback in the chain.
	#if defined FILTERSCRIPT
		public OnFilterScriptInit()
	#else
		public OnGameModeInit()
	#endif
	{
		P:1(#_YCM "_OGM");
		// THEN rename the callbacks.
		#if defined _YCM_CALLBACK
			#undef _YCM_CALLBACK
		#endif
		#if MASTER == 0
			#define _YCM_CALLBACK a@OnScriptInit
		#endif
		#if MASTER == 1
			#define _YCM_CALLBACK b@OnScriptInit
		#endif
		#if MASTER == 2
			#define _YCM_CALLBACK c@OnScriptInit
		#endif
		#if MASTER == 3
			#define _YCM_CALLBACK d@OnScriptInit
		#endif
		#if MASTER == 4
			#define _YCM_CALLBACK e@OnScriptInit
		#endif
		#if MASTER == 5
			#define _YCM_CALLBACK f@OnScriptInit
		#endif
		#if MASTER == 6
			#define _YCM_CALLBACK g@OnScriptInit
		#endif
		#if MASTER == 7
			#define _YCM_CALLBACK h@OnScriptInit
		#endif
		#if MASTER == 8
			#define _YCM_CALLBACK i@OnScriptInit
		#endif
		#if MASTER == 9
			#define _YCM_CALLBACK j@OnScriptInit
		#endif
		#if MASTER == 10
			#define _YCM_CALLBACK k@OnScriptInit
		#endif
		#if MASTER == 11
			#define _YCM_CALLBACK l@OnScriptInit
		#endif
		#if MASTER == 12
			#define _YCM_CALLBACK m@OnScriptInit
		#endif
		#if MASTER == 13
			#define _YCM_CALLBACK n@OnScriptInit
		#endif
		#if MASTER == 14
			#define _YCM_CALLBACK o@OnScriptInit
		#endif
		#if MASTER == 15
			#define _YCM_CALLBACK p@OnScriptInit
		#endif
		#if MASTER == 16
			#define _YCM_CALLBACK q@OnScriptInit
		#endif
		#if MASTER == 17
			#define _YCM_CALLBACK r@OnScriptInit
		#endif
		#if MASTER == 18
			#define _YCM_CALLBACK s@OnScriptInit
		#endif
		#if MASTER == 19
			#define _YCM_CALLBACK t@OnScriptInit
		#endif
		#if MASTER == 20
			#define _YCM_CALLBACK u@OnScriptInit
		#endif
		#if MASTER == 21
			#define _YCM_CALLBACK v@OnScriptInit
		#endif
		#if MASTER == 22
			#define _YCM_CALLBACK w@OnScriptInit
		#endif
		#if MASTER == 23
			#define _YCM_CALLBACK x@OnScriptInit
		#endif
		#if MASTER == 24
			#define _YCM_CALLBACK y@OnScriptInit
		#endif
		#if MASTER == 25
			#define _YCM_CALLBACK z@OnScriptInit
		#endif
		/*#if MASTER == 26
			#define _YCM_CALLBACK A@OnScriptInit
		#endif
		#if MASTER == 27
			#define _YCM_CALLBACK B@OnScriptInit
		#endif
		#if MASTER == 28
			#define _YCM_CALLBACK C@OnScriptInit
		#endif
		#if MASTER == 29
			#define _YCM_CALLBACK D@OnScriptInit
		#endif
		#if MASTER == 30
			#define _YCM_CALLBACK E@OnScriptInit
		#endif
		#if MASTER == 31
			#define _YCM_CALLBACK F@OnScriptInit
		#endif
		#if MASTER == 32
			#define _YCM_CALLBACK G@OnScriptInit
		#endif
		#if MASTER == 33
			#define _YCM_CALLBACK H@OnScriptInit
		#endif
		#if MASTER == 34
			#define _YCM_CALLBACK I@OnScriptInit
		#endif
		#if MASTER == 35
			#define _YCM_CALLBACK J@OnScriptInit
		#endif
		#if MASTER == 36
			#define _YCM_CALLBACK K@OnScriptInit
		#endif
		#if MASTER == 37
			#define _YCM_CALLBACK L@OnScriptInit
		#endif
		#if MASTER == 38
			#define _YCM_CALLBACK M@OnScriptInit
		#endif
		#if MASTER == 39
			#define _YCM_CALLBACK N@OnScriptInit
		#endif
		#if MASTER == 40
			#define _YCM_CALLBACK O@OnScriptInit
		#endif
		#if MASTER == 41
			#define _YCM_CALLBACK P@OnScriptInit
		#endif
		#if MASTER == 42
			#define _YCM_CALLBACK Q@OnScriptInit
		#endif*/
		#if YSIM_IS_SERVER
			// Steal the master.
			_Master_Get(#_YCM, true);
			CallRemoteFunction(#_YCM, "");
		#else
			#if YSIM_CLOUD
				// Determine the next unique name,
				// See if this script should be master.
				if (_Master_Get(#_YCM))
				{
					P:2("Got master " #_YCM);
					state _YCM:y;
				}
				else
				{
					state _YCM:n;
				}
			#endif
		#endif
		// FINALLY call the new next one.
		CallLocalFunction(#_YCM_CALLBACK, "");
	}
	
	// Don't need extra checks here as we KNOW it is already defined.
	#if defined FILTERSCRIPT
		#undef OnFilterScriptInit
		#define OnFilterScriptInit _YCM_CALLBACK
	#else
		#undef OnGameModeInit
		#define OnGameModeInit _YCM_CALLBACK
	#endif
	forward _YCM_CALLBACK();
#endif

// Undefine this before the next call.
#undef MASTER

// There are the following remote function definitions:
// 
// RF - A basic function.
// RF@p - A function with special parameters which need passing hints.
// RF@c - A function with lots of paramteres that needs special code.
// RF@v - A function with no return value.
// RF@n - A function with no parameters.
// RF@t - A function with a tag result.
// RC - A callback function.
// RF@p - A callback with special parameters which need passing hints.
// RF@c - A callback with lots of paramteres that needs special code.
// RF@v - A callback with no return value.
// RF@n - A callback with no parameters.
// 
// Supported combinations:
// 
// pc, cp
// pcv, pvc, cpv, cvp, vpc, vcp
// pv, vp
// cv, vc
// vn, nv
// cpt ctp pct ptc tcp tpc
// ct tc
// nt tn
// pt tp
// 
// p and c are for special parameter sets, n is for no parameters, so those two
// groups can never be mixed together.  t is for tag result and v is for no
// return, so they can never be used together.
// 
// Note that the callback thing won't work with OnPlayerCommandText as it has a
// different default return to everything else.
// 

// These parts are redefined every time the master system is included.
#if YSIM_HAS_MASTER
	#if YSIM_IS_CLIENT
		// Defined the functions as remote calling stubs.  Then rename the
		// following code with a name unlikely to ever be used and define the
		// functions as stock so the compiler removes all the code quietly.
		#define RF:%1[%2](%3) stock %1(%3)return U@(8,YSIM_CALLER,_@),W@(#@%1,#%2#x,%3),U@(8,YSIM_CALLER,-1),V@(8,YSIM_RETURN);stock _@%1(%3)
		#define RF@p:%1[%2](%3)<%4> stock %1(%3)return U@(8,YSIM_CALLER,_@),W@(#@%1,#%2,%4),U@(8,YSIM_CALLER,-1),V@(8,YSIM_RETURN);stock _@%1(%3)
		#define RF@c RF
		#define RF@v:%1[%2](%3) stock %1(%3)U@(8,YSIM_CALLER,_@),W@(#@%1,#%2#x,%3),U@(8,YSIM_CALLER,-1);stock _@%1(%3)
		//#define RF@n:%1[]() stock %1()return U@(8,YSIM_CALLER,_@),W@(#@%1,""),U@(8,YSIM_CALLER,-1),V@(8,YSIM_RETURN);stock _@%1()
		#define RF@pc RF@p
		#define RF@pv:%1[%2](%3)<%4> stock %1(%3)U@(8,YSIM_CALLER,_@),W@(#@%1,#%2,%4),U@(8,YSIM_CALLER,-1);stock _@%1(%3)
		#define RF@pcv RF@pv
		#define RF@vc RF@v
		//#define RF@vn:%1[]() stock %1()U@(8,YSIM_CALLER,_@),W@(#@%1,""),U@(8,YSIM_CALLER,-1);stock _@%1()
		
		#define RF@t:%0:%1[%2](%3) stock %0:%1(%3)return U@(8,YSIM_CALLER,_@),W@(#@%1,#%2#x,%3),U@(8,YSIM_CALLER,-1),%0:V@(8,YSIM_RETURN);stock %0:_@%1(%3)
		#define RF@pt:%0:%1[%2](%3)<%4> stock %0:%1(%3)return U@(8,YSIM_CALLER,_@),W@(#@%1,#%2,%4),U@(8,YSIM_CALLER,-1),%0:V@(8,YSIM_RETURN);stock %0:_@%1(%3)
		#define RF@ct RF@t
		//#define RF@nt:%0:%1[]() stock %0:%1()return U@(8,YSIM_CALLER,_@),W@(#@%1,""),U@(8,YSIM_CALLER,-1),%0:V@(8,YSIM_RETURN);stock %0:_@%1()
		#define RF@pct RF@pt
		
		#define RS:%1[%2](%3) stock %1(%3)return Y@(),W@(#@%1,#%2#x,%3),S@(),Q@;stock _@%1(%3)
		#define RS@p:%1[%2](%3)<%4> stock %1(%3)return Y@(),W@(#@%1,#%2#x,%4),S@(),Q@;stock _@%1(%3)
		
		#define RC:%1(%3) stock _@%1(%3)
		
		#define RH:%1_On%2(%3) stock %1_@%2(%3)
		
		#define Master_Caller() (-1)
	#else
		#if YSIM_IS_SERVER
			#define RF:%1[%2](%3) forward @%1(%3);@%1(%3)U@(8,YSIM_RETURN,%1(%3));%1(%3)
			#define RF@p:%1[%2](%3)<%4> forward @%1(%3);@%1(%3)U@(8,YSIM_RETURN,%1(%4));%1(%3)
			#define RF@c RF
			#define RF@v:%1[%2](%3) forward @%1(%3);@%1(%3)%1(%3);%1(%3)
			//#define RF@n:%1[]() forward %1R();public %1R()U@(8,YSIM_RETURN,%1());%1()
			#define RF@pc RF@p
			#define RF@pv:%1[%2](%3)<%4> forward @%1(%3);@%1(%3)%1(%4);%1(%3)
			#define RF@pcv RF@pv
			#define RF@vc RF@v
			//#define RF@vn:%1[]() forward %1R();public %1R()%1();%1()
			
			#define RF@t:%0:%1[%2](%3) forward %0:%1(%3);forward @%1(%3);@%1(%3)U@(8,YSIM_RETURN,_:%1(%3));%0:%1(%3)
			#define RF@pt:%0:%1[%2](%3)<%4> forward %0:%1(%3);forward @%1(%3);@%1(%3)U@(8,YSIM_RETURN,_:%1(%4));%0:%1(%3)
			#define RF@ct RF@t
			//#define RF@nt:%0:%1[]() forward %0:%1();forward %1R();public %1R()U@(8,YSIM_RETURN,_:%1());%0:%1()
			#define RF@pct RF@pt
			
			#define RS:%1[%2](%3) forward @%1(%3);@%1(%3)R@(%1(%3));%1(%3)
			#define RS@p:%1[%2](%3)<%4> forward @%1(%3);@%1(%3)R@(%1(%4));%1(%3)
			
			#define RC:%1(%3) public %1(%3)
			
			#define RH:%1_On%2(%3) forward %1_@%2(%3);public %1_@%2(%3)
			
			#define Master_Caller() \
				(V@(8,YSIM_CALLER))
			
			//#define Master_Get(%1) state (_Master_Get(#%1)) ? (%1:y) : (%1:n)
			//#define Master_Init(%1); _Master_Get(#%1);
		#else
			// This is a normal system with the possibility of being the master.
			// This is the very complicated one to write!
			#define RF:%1[%2](%3) forward @%1(%3);@%1(%3)<>{}@%1(%3)<_YCM:y>U@(8,YSIM_RETURN,%1(%3));%1(%3)<>return U@(8,YSIM_CALLER,_@),W@(#@%1,#%2#x,%3),U@(8,YSIM_CALLER,-1),V@(8,YSIM_RETURN);%1(%3)<_YCM:y>
			#define RF@p:%1[%2](%3)<%4> forward @%1(%3);@%1(%3)<>{}@%1(%3)<_YCM:y>U@(8,YSIM_RETURN,%1(%4));%1(%3)<>return U@(8,YSIM_CALLER,_@),W@(#@%1,#%2,%4),U@(8,YSIM_CALLER,-1),V@(8,YSIM_RETURN);%1(%3)<_YCM:y>
			#define RF@c:%1[%2](%3) forward @%1(%3);@%1(%3)<>{}@%1(%3)<_YCM:y>X@(%1(%3));%1(%3)<>return Y@(),W@(#@%1,#%2#x,%3),Z@();%1(%3)<_YCM:y>
			#define RF@v:%1[%2](%3) forward @%1(%3);@%1(%3)<>{}@%1(%3)<_YCM:y>%1(%3);%1(%3)<>U@(8,YSIM_CALLER,_@),W@(#@%1,#%2#x,%3),U@(8,YSIM_CALLER,-1);%1(%3)<_YCM:y>
			//#define RF@n:%1[]() forward %1R();public %1R()<>{}public %1R()<_YCM:y>U@(8,YSIM_RETURN,%1());%1()<>return U@(8,YSIM_CALLER,_@),W@(#@%1,""),U@(8,YSIM_CALLER,-1),V@(8,YSIM_RETURN);%1()<_YCM:y>
			#define RF@pc:%1[%2](%3)<%4> forward @%1(%3);@%1(%3)<>{}@%1(%3)<_YCM:y>X@(%1(%4));%1(%3)<>return Y@(),W@(#@%1,#%2,%4),Z@();%1(%3)<_YCM:y>
			#define RF@pv:%1[%2](%3)<%4> forward @%1(%3);@%1(%3)<>{}@%1(%3)<_YCM:y>%1(%4);%1(%3)<>U@(8,YSIM_CALLER,_@),W@(#@%1,#%2,%4),U@(8,YSIM_CALLER,-1);%1(%3)<_YCM:y>
			#define RF@pcv:%1[%2](%3)<%4> forward @%1(%3);@%1(%3)<>{}@%1(%3)<_YCM:y>%1(%4);%1(%3)<>Y@(),W@(#@%1,#%2,%4),T@();%1(%3)<_YCM:y>
			#define RF@vc:%1[%2](%3) forward @%1(%3);@%1(%3)<>{}@%1(%3)<_YCM:y>%1(%3);%1(%3)<>Y@(),W@(#@%1,#%2#x,%3),T@();%1(%3)<_YCM:y>
			//#define RF@vn:%1[]() forward %1R();public %1R()<>{}public %1R()<_YCM:y>%1();%1()<>U@(8,YSIM_CALLER,_@),W@(#@%1,""),U@(8,YSIM_CALLER,-1);%1()<_YCM:y>
			
			#define RF@t:%0:%1[%2](%3) forward %0:%1(%3);forward @%1(%3);@%1(%3)<>{}@%1(%3)<_YCM:y>U@(8,YSIM_RETURN,_:%1(%3));%0:%1(%3)<>return U@(8,YSIM_CALLER,_@),W@(#@%1,#%2#x,%3),U@(8,YSIM_CALLER,-1),%0:V@(8,YSIM_RETURN);%0:%1(%3)<_YCM:y>
			#define RF@pt:%0:%1[%2](%3)<%4> forward %0:%1(%3);forward @%1(%3);@%1(%3)<>{}@%1(%3)<_YCM:y>U@(8,YSIM_RETURN,_:%1(%4));%0:%1(%3)<>return U@(8,YSIM_CALLER,_@),W@(#@%1,#%2,%4),U@(8,YSIM_CALLER,-1),%0:V@(8,YSIM_RETURN);%0:%1(%3)<_YCM:y>
			#define RF@ct:%0:%1[%2](%3) forward %0:%1(%3);forward @%1(%3);@%1(%3)<>{}@%1(%3)<_YCM:y>X@(_:%1(%3));%0:%1(%3)<>return Y@(),W@(#@%1,#%2#x,%3),%0:Z@();%0:%1(%3)<_YCM:y>
			//#define RF@nt:%0:%1[]() forward %0:%1();forward %1R();public %1R()<>{}public %1R()<_YCM:y>U@(8,YSIM_RETURN,_:%1());%0:%1()<>return U@(8,YSIM_CALLER,_@),W@(#@%1,""),U@(8,YSIM_CALLER,-1),%0:V@(8,YSIM_RETURN);%0:%1()<_YCM:y>
			#define RF@pct:%0:%1[%2](%3)<%4> forward %0:%1(%3);forward @%1(%3);@%1(%3)<>{}@%1(%3)<_YCM:y>X@(_:%1(%4));%0:%1(%3)<>return Y@(),W@(#@%1,#%2,%4),%0:Z@();%0:%1(%3)<_YCM:y>
			
			//#define RS:%1[%2](%3) forward %1R(%3);public %1R(%3)<>{}public %1R(%3)<_YCM:y>R@(%1(%3));%1(%3)<>return Y@(),W@(#@%1,#%2#x,%3),S@();%1(%3)<_YCM:y>
			#define RS:%1[%2](%3) forward @%1(%3);@%1(%3)<>{}@%1(%3)<_YCM:y>R@(%1(%3));%1(%3)<>return Y@(),W@(#@%1,#%2#x,%3),S@(),Q@;%1(%3)<_YCM:y>
			#define RS@p:%1[%2](%3)<%4> forward @%1(%3);@%1(%3)<>{}@%1(%3)<_YCM:y>R@(%1(%4));%1(%3)<>return Y@(),W@(#@%1,#%2,%4),S@(),Q@;%1(%3)<_YCM:y>
			
			#define RC:%1(%3) public %1(%3)<>return 1;public %1(%3)<_YCM:y>
			
			// Requires the y_hooks library.
			#define RH:%1_On%2(%3) forward %1_@%2(%3);public %1_@%2(%3)<>return 1;public %1_@%2(%3)<_YCM:y>
			
			#define Master_Caller() \
				((V@(8,YSIM_CALLER)==-1)?(_@):(V@(8,YSIM_CALLER)))
			
			//#define Master_Get(%1) state (_Master_Get(#%1)) ? (%1:y) : (%1:n)
			//#define Master_Init(%1); if (_Master_Get(#%1)) state %1:y; else state %1:n;
		#endif
	#endif
#else
	// Master system isn't used.
	#define RF:%1[%2](%3) stock %1(%3)
	#define RF@p:%1[%2](%3)<%4> RF:%1[%2](%3)
	#define RF@c RF
	#define RF@v RF
	//#define RF@n RF
	#define RF@pc RF@p
	#define RF@pv RF@p
	#define RF@pcv RF@p
	#define RF@vc RF
	//#define RF@vn RF
	
	#define RF@t:%0:%1[%2](%3) stock %0:%1(%3)
	#define RF@pt:%0:%1[%2](%3)<%4> RF@t:%0:%1[%2](%3)
	#define RF@ct RF@t
	//#define RF@nt RF@t
	#define RF@pct RF@p
	
	#define RS:%1[%2](%3) stock %1(%3)
	#define RS@p:%1[%2](%3)<%4> stock %1(%3)
	
	#define RC:%1(%3) public %1(%3)
	
	#define RH:%1_On%2(%3) forward %1_@%2(%3);public %1_@%2(%3)
	
	#define Master_Caller() (_@)
	
	//#define Master_Init(%1);
#endif

#if YSIM_CLOUD && !defined YSIM_DEFINED
	// Define a load of fake functions to cater for the compiler's need to
	// know all the possible states.  y means master, n means not master, m
	// means master system missing, p means previous (ending master), u
	// means sort of uninitialised (though technically initialised).  This
	// also doubles as a handy call in function for resetting masters when a
	// script ends.  Just to clarify - this function is NOT called _YCM,
	// that is a macro which is expanded every time this file is included.
	forward _YCM();
	public _YCM() <_YCM:y>
	{
		if (getproperty(8, #_YCM) != _@)
		{
			// Master, but not.  A server has claimed this.
			state _YCM:n;
		}
		else
		{
			P:2(#_YCM ":y called");
			// Disable the current mastership.
			state _YCM:p;
			setproperty(8, #_YCM, -1);
			// Called locally to begin the hand off process.
			CallRemoteFunction(#_YCM, "");
		}
	}
	
	public _YCM() <_YCM:n>
	{
		P:2(#_YCM ":n called");
		// This has been called remotely from a script which owns the
		// library masterhood (that's the only way this can ever be called).
		if (_Master_Get(#_YCM))
		{
			P:2("Got master " #_YCM);
			state _YCM:y;
		}
	}
	
	public _YCM() <_YCM:m, _YCM:p, _YCM:u>
	{
		P:2(#_YCM ":mpu called");
		// Do nothing at all (just define states).
	}
	
	public _YCM() <>
	{
		P:2(#_YCM ":<> called");
		if (_Master_Get(#_YCM))
		{
			P:2("Got master " #_YCM);
			state _YCM:y;
		}
		else
		{
			state _YCM:n;
		}
		// Do nothing at all (just define states).
	}
#endif

#if defined YSIM_T_ENABLE
	#undef YSIM_T_ENABLE
#endif

#if defined YSIM_T_DISABLE
	#undef YSIM_T_DISABLE
#endif

#if defined YSIM_C_ENABLE
	#undef YSIM_C_ENABLE
#endif

#if defined YSIM_C_DISABLE
	#undef YSIM_C_DISABLE
#endif

#if defined YSIM_S_ENABLE
	#undef YSIM_S_ENABLE
#endif

#if defined YSIM_S_DISABLE
	#undef YSIM_S_DISABLE
#endif

// Allow YSI scripts to use the extended master system
#if defined _YSIM_USED_AUTO
	#undef _YSIM_USED_AUTO
#endif

#if defined _YSIM_OVERRIDE
	#undef _YSIM_OVERRIDE
#endif

#if defined YSIM_STORED_SETTINGS
	#undef YSIM_STORED_SETTINGS
#endif
