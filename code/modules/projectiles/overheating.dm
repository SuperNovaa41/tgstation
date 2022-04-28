/obj/item/gun/projectile
	/// Set to the time it won't be overheated anymore
	var/overheated = 0
	/// Current overheat level the gun is right now
	var/overheat = 0
	/// Increases overheat by [over_heat_rate] per shot.
	var/overheat_rate = 0
	/// The maximum amount of heat/cold that can be stored, if zero, does not overheat.
	var/overheat_limit = 0
	/// The time it takes to cool down from overheating
	var/overheat_time = 0

/obj/item/gun/projectile/examine(mob/user)
	. = ..()
	if(overheated > world.time)
		switch(get_overheat_state())
			if("hot")
				. += "\The [src] is overheated and won't fire!"

/obj/item/gun/projectile/proc/handle_overheat()
	if(overheat_limit && overheat_rate && overheat_time)
		overheat += overheat_rate
		switch(overheat_limit)
			if(1 to INFINITY)
				if(overheat > overheat_limit)
					overheated = world.time + overheat_time
					visible_message("<span class='warning'>\The [src] overheats!</span>", null, 3)

/obj/item/gun/projectile/proc/is_overheated()
	if(overheated > world.time)
		switch(get_overheat_state())
			if("hot")
				to_chat(usr, "\The [src] is overheated and won't fire!")
				return TRUE
	else if(overheat && (overheated < world.time))
		switch(get_overheat_state())
			if("hot")
				if(overheat > overheat_limit)
					overheat = 0
					to_chat(usr, "\The [src] is no longer overheated.")

/obj/item/gun/projectile/proc/get_overheat_state()
	switch(overheat)
		if(1 to INFINITY)
			return "hot"

/obj/item/gun/projectile/proc/adjustHeat(var/extra_heat)
	if(overheat >= overheat_limit)
		handle_overheat()
	else if(overheat >= overheat_limit * 0.75)
		to_chat(user, SPAN_HIGHDANGER("[src] is critically hot, it feels like it will overheat shortly!"))
	else if(overheat >= overheat_limit  * 0.50)
		to_chat(user, SPAN_DANGER("[src] is getting terribly hot, but is still able to fire."))
	else if(overheat >= overheat_limit * 0.25)
		to_chat(user, SPAN_DANGER("[src] is starting to get pretty hot, although it's still stable."))