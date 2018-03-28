/*******************************************************************************
Copyright © 2012 DuPont. All rights reserved. 
Author: Thomas Snyder
Email: thomas.snyder@usa.dupont.com, tom@3ddd.com
Description: general trigger fro NoteThis not batchable trigger will check the parent object of the attachment
for the extistance of the field HAS_NOTE_FIELD and update it appropriatly if available.
***********************************************************/
public class NoteHandler extends TriggerHandlerBase {

	private static boolean InProcess = false;	//avoid recursion incase another trigger autocreates an Note

    public override void bulkAfter(){

		if (Trigger.isInsert || Trigger.isUnDelete) {
			if (! InProcess) {
				InProcess=true;
				HasAttachment.ProcessHasNoteOrAttachment(Trigger.new, false, HasAttachment.HAS_NOTE_FIELD ); 
			}
		}
			
		if (Trigger.isDelete) {
			HasAttachment.ProcessHasNoteOrAttachment(Trigger.old, true, HasAttachment.HAS_NOTE_FIELD); 
		}
	}	
         	
}