program RogTextAdventure_Delphi;

{$APPTYPE CONSOLE}

{$R *.res}
{

Ported from the Visual Basic version
Disabled code hgas been deleted
Original comments included


This was a tough converiosn, for reasons illogical there is no console class in Delphi so any interactions
with the console outside of read and write can only be done through the Windows API
How old fashioned! However things get worse as even though the console has a window there is no way to get the
window handle in Delphi!

GetWindowHandle does not return the console handle in Delphi so that was a non starter
GetForegroundWindow - same
GetStdHandle - works"

Risky as how can I guarantee it will get THIS console window amd not another that is currently open?

Also TList in Delphi doesnt work the same way as List in Dot Net, have to populate the values at RUNTIME
like being in the dark ages...also cannot define default values for variables, what year is it again?

NOTE: the C# version needed the console one column WIDER Delphi requires it is one ROW longer to show
      the same data!

A lovely language ruined by years of laughably slow development and the "code completion" is mostly useless
(when it works)



'Created 23/07/2024 By Roger Williams
'
'text adventure game!
'
'features a basic parser!
'
'This is Phase one of a potential three phase developmet:
'
'Phase One   - basic game design with movement and primitive parser framework
'Phase Two   - add objects into the rooms and ability to interact better parser
'Phase Three - add entities and action rooms where a list of actions is available e.g. run, stop etc.
'
'NOTE: currently levels have 20 lines of descriptive text, allowing for the 42 row screen leaves around
'      lines for future use
'
'
}

uses
  System.SysUtils,Winapi.Windows,System.Classes,System.AnsiStrings,
  clsGameRooms in 'clsGameRooms.pas',    //welcome to the mid 90s!
  clsROGParser in 'clsROGParser.pas';

var
    clsParser  : TclsROGParser;                   //the parser class
    lstRooms   : array [1..23] of TclsGameRooms;  //'collection of all rooms in the level
    clsCurRoom : TclsGameRooms;                   //'current rrom player is in
    intCurRoom : Integer;                         //'ID of above
    //console vars
    coCoord    : TCOORD;
    hndConsole : THandle;
    //other vars
    strInput   : string;
    intNum     : integer;

procedure ClrScr;
{
 Created 29/07/2024 By Roger Williams

 Delphi has no method to clear the console so I wrote one
 not pretty but it works

}
var
 intNum  : integer;
 strTemp : string;

begin
//fille string with 120 spaces
strTemp:=StringOfChar(' ',121);
//Move the cursor home
coCoord.X:=0;
coCoord.Y:=0;
SetConsoleCursorPosition(hndConsole, coCoord);
//set colour
SetConsoleTextAttribute(hndConsole, 31);
//write blank lines
 for intNum:=0 to 42 do
 begin
  write(strTemp);
 end;
end;

function CheckIfEnd: Boolean;
{
        'Created 30/07/2024 By Roger Williams
        '
        'checks if there are NO directions the player can move to
        '
        'this merans end of game!
        '
        '
}
begin
 result := (clsCurRoom.NextRoomEast = 0) And (clsCurRoom.NextRoomNorth = 0) And (clsCurRoom.NextRoomSouth = 0) And (clsCurRoom.NextRoomWest = 0);
end;

procedure ShowRoom(intWhat : Integer);
{
        'Created 24/07/2024 By Roger Williams
        '
        'draws room description fields to console
        '
}
begin
//'only use intWhat if first room
 if intWhat = 1 then
 begin
  intCurRoom := intWhat;
  clsCurRoom := lstRooms[intWhat];
 end;

 // 'clear console and set cursor in the "home" position
  ClrScr;
  //set console for main game look
  SetConsoleTextAttribute(hndConsole, 31);
  coCoord.X := 0;
  coCoord.Y := 0;
  SetConsoleCursorPosition(hndConsole, coCoord);
  //'write room description
  Writeln(clsCurRoom.Desc1);
  Writeln(clsCurRoom.Desc2);
  Writeln(clsCurRoom.Desc3);
  Writeln(clsCurRoom.Desc4);
  Writeln(clsCurRoom.Desc5);
  Writeln(clsCurRoom.Desc6);
  Writeln(clsCurRoom.Desc7);
  Writeln(clsCurRoom.Desc8);
  Writeln(clsCurRoom.Desc9);
  Writeln(clsCurRoom.Desc10);
  Writeln(clsCurRoom.Desc11);
  Writeln(clsCurRoom.Desc12);
  Writeln(clsCurRoom.Desc13);
  Writeln(clsCurRoom.Desc14);
  Writeln(clsCurRoom.Desc15);
  Writeln(clsCurRoom.Desc16);
  Writeln(clsCurRoom.Desc17);
  Writeln(clsCurRoom.Desc18);
  Writeln(clsCurRoom.Desc19);
  Writeln(clsCurRoom.Desc20);
  Writeln;
  Writeln('Enter Command:');
end;

procedure ShowTitle;
{
        'Created 23/07/2024 By Roger Williams
        '
        'shows title screen
        '
        'works thus:
        '
        'the intro screen comprises of TWO text files:
        '
        '    introscr1.txt
        '    introscr2.txt
        '
        'these are loaded into two variables then written one at a time to the console and the
        'background/foreground colour is changed
        '
        '

  handily Delphi has a textfile class, this is straight from Turbo Pascal - ah memories!!
}
   var
      bytNum1    : Byte;
      strmIntro1 : TextFile;     //'used for readaing the text files in
      strmIntro2 : TextFile;
      strIntro1  : String;      //used for holding the intro files data
      strIntro2  : String;
      strData    : String;

   begin
     ClrScr;
    //set cursor to home position
      coCoord.X := 0;
      coCoord.Y := 0;
      SetConsoleCursorPosition(hndConsole, coCoord);

      //'read intro screen files into strings
      AssignFile(strmIntro1,'INTROSCR1.txt');
      AssignFile(strmIntro2,'INTROSCR2.txt');
      Reset(strmIntro1);
      Reset(strmIntro2);
      strIntro1:='';
      strIntro2:='';
      //read level 1 into string
      while not eof(strmIntro1) do
      begin
        Readln(strmIntro1,strData);
        strIntro1:=strIntro1+strData;
      end;
      //read level 2 into string
      while not eof(strmIntro2) do
      begin
        Readln(strmIntro2,strData);
        strIntro2:=strIntro2+strData;
      end;

      //close text files
      CloseFile(strmIntro1);
      CloseFile(strmIntro2);

      //flash colours on first screen
      For bytNum1 := 0 To 6 do
      begin
        //set cursor to home position
        coCoord.X := 0;
        coCoord.Y := 0;
        SetConsoleCursorPosition(hndConsole, coCoord);
          //if 0 show onbe colour else show other
          if bytNum1 Mod 2 = 0 Then
             begin
              SetConsoleTextAttribute(hndConsole, 26);
              writeln(strIntro1);
             end
          else
            begin
               SetConsoleTextAttribute(hndConsole, 18);
               writeln(strIntro1);
            end;
          //wait so user can see the change
          Sleep(1000);
      end;

      //flash colours on second screen
      For bytNum1 := 0 To 6 do
      begin
          If bytNum1 Mod 2 = 0 Then
             begin
              SetConsoleTextAttribute(hndConsole, 49);
              writeln(strIntro2);
             end
          Else
            begin
               SetConsoleTextAttribute(hndConsole, 63);
               writeln(strIntro2);
             end;
          // //wait so user can see the change
          Sleep(1000);
      end;

      //'show first proper game screen
      ClrScr;
      //'display room 1
      ShowRoom(1);
end;

procedure LoadLeve1;
{
        'Created 23/07/2024 By Roger Williams
        '
        'loads level 1 from level1.txt into lstRooms which is a collection of clsGameRooms
        'level text file format matches the class structure
        '
}
    var
         strmRead : TextFile; //stream? I got no time to stream!
         strTemp  : string;
         strData  : string;
         intNum   : integer;

    begin
        //open level file
        //NOTE still uses same commands from Turbo Pascal in the early 90s!
        AssignFile(strmRead,'level1.txt');
        Reset(strmRead);

        //clear level array values
        for intNum:= 1 To 20 do
        begin
          lstRooms[intNum]:=nil;
        end;

        //'first add blank class object : ew need 0 to represent null and index 1 = room 1
        clsCurRoom := TclsGameRooms.Create;
//        lstRooms .Add(clsCurRoom);
        intNum:=1;

        While Not eof(strmRead) do
        begin
            //'recreate the class object else carries over previous values!
            clsCurRoom := TclsGameRooms.Create;
            Readln(strmRead,strData);
            clsCurRoom.ID := StrToInt(strData);
            Readln(strmRead,StrData);
            clsCurRoom.NextRoomNorth := StrToInt(strData);
            Readln(strmRead,StrData);
            clsCurRoom.NextRoomSouth := StrToInt(strData);
            Readln(strmRead,StrData);
            clsCurRoom.NextRoomEast := StrToInt(strData);
            Readln(strmRead,StrData);
            clsCurRoom.NextRoomWest := StrToInt(strData);
            //'read rooms description
            Readln(strmRead,StrData);
            clsCurRoom.Desc1 := strData;
            Readln(strmRead,StrData);
            clsCurRoom.Desc2 := strData;
            Readln(strmRead,StrData);
            clsCurRoom.Desc3 := strData;
            Readln(strmRead,StrData);
            clsCurRoom.Desc4 := strData;
            Readln(strmRead,StrData);
            clsCurRoom.Desc5 := strData;
            Readln(strmRead,StrData);
            clsCurRoom.Desc6 := strData;
            Readln(strmRead,StrData);
            clsCurRoom.Desc7 := strData;
            Readln(strmRead,StrData);
            clsCurRoom.Desc8 := strData;
            Readln(strmRead,StrData);
            clsCurRoom.Desc9 := strData;
            Readln(strmRead,StrData);
            clsCurRoom.Desc10 := strData;
            Readln(strmRead,StrData);
            clsCurRoom.Desc11 := strData;
            Readln(strmRead,StrData);
            clsCurRoom.Desc12 := strData;
            Readln(strmRead,StrData);
            clsCurRoom.Desc13 := strData;
            Readln(strmRead,StrData);
            clsCurRoom.Desc14 := strData;
            Readln(strmRead,StrData);
            clsCurRoom.Desc15 := strData;
            Readln(strmRead,StrData);
            clsCurRoom.Desc16 := strData;
            Readln(strmRead,StrData);
            clsCurRoom.Desc17 := strData;
            Readln(strmRead,StrData);
            clsCurRoom.Desc18 := strData;
            Readln(strmRead,StrData);
            clsCurRoom.Desc19 := strData;
            Readln(strmRead,StrData);
            clsCurRoom.Desc20 := strData;
            //'store in level room list
            lstRooms[intNum]:=clsCurRoom;
            Inc(intNum);
        end;
        //close text file
        CloseFile(strmRead);
    end;

procedure ExitProgram;
{
        'Created 24/07/2024 By Roger Williams
        '
        'technically pointless as the console will just close, but in Visual Stdudio it will wait for a keypress!
        '
}
begin
        Writeln('Bye"');
end;

procedure Init();
{
        'Created 23/07/2024 By Roger Williams
        '
        'initialises the console, set title, colours etc and show title screen
        '
        '
}
var
  Rect: TSmallRect;

begin
//get console handle as Delphi doesnt give the console window it creates a handle (??)
hndConsole:=GetStdHandle(STD_OUTPUT_HANDLE);
Rect.Left := 1;
Rect.Top := 1;
Rect.Right := 120;
Rect.Bottom := 43;
//set console size the old way via API
coCoord.X := Rect.Right + 1 - Rect.Left;
coCoord.y := Rect.Bottom + 1 - Rect.Top;
SetConsoleScreenBufferSize(hndConsole, coCoord);
SetConsoleWindowInfo(hndConsole, True, Rect);
//load level show title screen
LoadLeve1;
//set title show intro
SetConsoleTitle('Rog''s Adventure!');
ShowTitle;
end;


begin
 try
   begin
     intCurRoom:=0;
     Init;
     strInput:=' ';
     clsParser:=TclsROGParser.Create;
     //loop till player leaves
     while strInput <> 'exit' do
     begin
       Readln(strInput);
       clsParser.ParseText(strInput);  //get user instructions
       //validate
       If clsParser.isOk Then
       begin
          If ((strInput.Contains('go')) Or (strInput.Contains('move'))) Then
          begin
           //'set to current room number - why? because if the direction is VALID
           //'the room number will change
           intNum := intCurRoom;

           //'south is forward, north backward, east/west left/right
           Case IndexStr(clsParser.Direction,['north','south','east','west']) of
              0:
             begin
                If clsCurRoom.NextRoomNorth <> 0 Then
                   //'move north
                  intCurRoom := clsCurRoom.NextRoomNorth;
             end;
             1:
             begin
                If clsCurRoom.NextRoomSouth <> 0 Then
                   //'move south
                  intCurRoom := clsCurRoom.NextRoomSouth;
             end;
             2:
             begin
                If clsCurRoom.NextRoomEast <> 0 Then
                   //'move east
                   intCurRoom := clsCurRoom.NextRoomEast;
             end;
             3:
             begin
                If clsCurRoom.NextRoomWest <> 0 Then
                   //'move west
                   intCurRoom := clsCurRoom.NextRoomWest;
             end;
           end;
           //if room number hasnt changed user instruction not recognised
           If intNum = intCurRoom Then
           begin
              WriteLn('Sorry! - Direction entered isnt available! Please try again');
              strInput:='';
              // 'wait before redrawing screen
              Sleep(3000);
           end;

           //'shows new or even existing room
           clsCurRoom := lstRooms[intCurRoom];
           ShowRoom(intCurRoom);
           //has the user won/lost?
           if CheckIfEnd then
           begin
             //set command to exit
             strInput:='exit';
           end
         else
          begin
            //if command not exit or help and not recognised by parser
            If ((strInput <> 'help') and (strInput <> 'exit')) Then
               if (clsParser.isOk = false) then
               begin
                 WriteLn('Unregonised command, please tgry again!');
                 //clear command string
                 strInput := '';
                 //wait so user can see message
                 Sleep(4000);
                 //redisplay current room
                 ShowRoom(0);
               end;
          end;
         end
         else
          begin
            //if command not exit or help and not recognised by parser
            if (strInput.IndexOf('help') = -1) then
               if (strInput <> 'exit') then
                  WriteLn('Unregonised command, please tgry again!');

            if strInput <> 'exit' then
            begin
               //clear command string
               strInput:='';
               //wait so user can see message
               Sleep(2000);
               //redisplay current room
               ShowRoom(0);
            end;
          end;
       end;
    end;
   end;
except
    on E: Exception do
      begin
      //this code is created by Delphi so I left it in!
        Writeln(E.ClassName, ': ', E.Message);
        ExitCode:=-1;
      end;
end;
end.
