public class UtilPermissionSet {
	public static List<String> getPermissionSetNames(Id userId){
		List<PermissionSetAssignment> psList = [SELECT PermissionSet.Label FROM PermissionSetAssignment WHERE AssigneeId = :userId];
		List<String> permissionSetNames = new List<String>();
		for(PermissionSetAssignment ps : psList){
			permissionSetNames.add(ps.PermissionSet.Label);
		}
		return permissionSetNames;
	}
	
	public static Boolean hasPermissionSet(Id userId, String name){
		List<PermissionSetAssignment> psList = [SELECT id FROM PermissionSetAssignment WHERE AssigneeId=:userId AND PermissionSet.Label=:name LIMIT 1];
		return !psList.isEmpty();
	}
}