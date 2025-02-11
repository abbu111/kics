package Cx

import data.generic.terraform as tf_lib

CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[primary]
	not resource.master_auth

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_container_cluster",
		"resourceName": tf_lib.get_resource_name(resource, primary),
		"searchKey": sprintf("google_container_cluster[%s]", [primary]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Attribute 'master_auth' should be defined",
		"keyActualValue": "Attribute 'master_auth' is undefined",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[primary]

	not bothDefined(resource.master_auth)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_container_cluster",
		"resourceName": tf_lib.get_resource_name(resource, primary),
		"searchKey": sprintf("google_container_cluster[%s].master_auth", [primary]),
		"issueType": "MissingAttribute",
		"keyExpectedValue": "Both attribute 'master_auth.username' and 'master_auth.password' should be defined and empty",
		"keyActualValue": "Attribute 'username' is undefined or attribute 'master_auth' is undefined",
	}
}

CxPolicy[result] {
	resource := input.document[i].resource.google_container_cluster[primary]

	bothDefined(resource.master_auth)
	not bothEmpty(resource.master_auth)

	result := {
		"documentId": input.document[i].id,
		"resourceType": "google_container_cluster",
		"resourceName": tf_lib.get_resource_name(resource, primary),
		"searchKey": sprintf("google_container_cluster[%s].master_auth", [primary]),
		"issueType": "IncorrectValue",
		"keyExpectedValue": "Both attribute 'master_auth.username' and 'master_auth.password' should be defined and empty",
		"keyActualValue": "Attribute 'username' is not empty or attribute 'master_auth' is not empty",
	}
}

bothDefined(master_auth) {
	master_auth.username
	master_auth.password
}

bothEmpty(master_auth) {
	count(master_auth.username) == 0
	count(master_auth.password) == 0
}
