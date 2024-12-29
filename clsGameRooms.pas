unit clsGameRooms;

interface

Type
  TclsGameRooms = Class
{
Ported from the Visual Basic version
Original comments kept


'Created 24/07/2024 By Roger Williams
'
'used to store rooms for each level in memory
'
'uses a class structure and main program uses list of this class to represent the entire level
'room data stored in a text file which the main program reads and stores each room data into
'its own class object - not very 80s!
'
'
'
}

//NOTE: if class is NOT put in the interface section it is invisible to the outside world!
  public
     ID : Integer;
     NextRoomNorth : Integer;
     NextRoomSouth : Integer;
     NextRoomEast  : Integer;
     NextRoomWest  : Integer;
     //'used for text to describe room to player
     Desc1 : String;
     Desc2 : String;
     Desc3 : String;
     Desc4 : String;
     Desc5 : String;
     Desc6 : String;
     Desc7 : String;
     Desc8 : String;
     Desc9 : String;
     Desc10 : String;
     Desc11 : String;
     Desc12 : String;
     Desc13 : String;
     Desc14 : String;
     Desc15 : String;
     Desc16 : String;
     Desc17 : String;
     Desc18 : String;
     Desc19 : String;
     Desc20 : String;
    //subs/functions
    procedure Clear;
    constructor Create;
  protected
  published
end;

implementation

 procedure TclsGameRooms.Clear;
  {
        'Created 24/07/2024 By Roger Williams
        '
        'resets class variables
        '
        '
   }
   begin
        ID := 0;
        NextRoomNorth:= 0;
        NextRoomSouth:= 0;
        NextRoomEast:= 0 ;
        NextRoomWest:= 0 ;
        //'used for text to descrbie room to player
        Desc1:= '';
        Desc2:= '';
        Desc3:= '';
        Desc4:= '';
        Desc5:= '';
        Desc6:= '';
        Desc7:= '';
        Desc8:= '';
        Desc9:= '';
        Desc10:= '';
        Desc11:= '';
        Desc12:= '';
        Desc13:= '';
        Desc14:= '';
        Desc15:= '';
        Desc16:= '';
        Desc17:= '';
        Desc18:= '';
        Desc19:= '';
        Desc20:= '';
   end;

 constructor TclsGameRooms.Create;
 begin
  Clear;
 end;

initialization
finalization

end.
