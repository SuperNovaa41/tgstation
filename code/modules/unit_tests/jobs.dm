/datum/unit_test/jobs

/datum/unit_test/jobs/Run()
	for (var/datum/job/job in subtypesof(/datum/job))
		if (job.title in GLOB.crewmonitor.jobs)
			continue
		TEST_FAIL("[job.title] not found in /datum/crewmonitor jobs list.")
