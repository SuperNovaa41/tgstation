/obj/item/implant/storage
	name = "storage implant"
	desc = "Stores up to two big items in a bluespace pocket."
	icon_state = "storage"
	implant_color = "r"
	var/max_slot_stacking = 4

/obj/item/implant/storage/activate()
	. = ..()
	SEND_SIGNAL(src, COMSIG_TRY_STORAGE_SHOW, imp_in, TRUE)

/obj/item/implant/storage/removed(source, silent = FALSE, special = 0)
	if(!special)
		var/datum/component/storage/lostimplant = GetComponent(/datum/component/storage/concrete/implant)
		var/mob/living/implantee = source
		for (var/obj/item/implant_contents as anything in lostimplant.contents())
			implant_contents.add_mob_blood(implantee)
		lostimplant.do_quick_empty()
		implantee.visible_message(span_warning("A bluespace pocket opens around [src] as it exits [implantee], spewing out its contents and rupturing the surrounding tissue!"))
		implantee.apply_damage(20, BRUTE, BODY_ZONE_CHEST)
		qdel(lostimplant)
	return ..()

/obj/item/implant/storage/implant(mob/living/target, mob/user, silent = FALSE, force = FALSE)
	for(var/implant as anything in target.implants)
		if (!istype(implant, type))
			continue
		var/obj/item/implant/storage/imp_e = implant
		var/datum/component/storage/STR = imp_e.GetComponent(/datum/component/storage)
		if(!STR || (STR && STR.max_items < max_slot_stacking))
			imp_e.AddComponent(/datum/component/storage/concrete/implant)
			qdel(src)
			return TRUE
		return FALSE
	AddComponent(/datum/component/storage/concrete/implant)

	return ..()

/obj/item/implanter/storage
	name = "implanter (storage)"
	imp_type = /obj/item/implant/storage
