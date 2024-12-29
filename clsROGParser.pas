unit clsROGParser;

interface

uses System.Generics.Collections, Windows;

type
  TclsROGParser = class
{

Ported from the Visual Basic version
Disabled code hgas been deleted
Original comments included


    'Created 23/07/2024 By Roger Williams
    '
    'What It Does
    '------------
    '
    'checks passed text to try and determine if statement valid
    '
    '- passes through all the lists
    '- checks for duplicates
    '- checka valid querry
    '-
    '
    'e.g.:
    '
    'open door with the key
    '
    'run away
    '
    'would produce response:
    ' which direction?
    '
    'run away north
    '
    'would produce response:
    '  you ran north
    '
}
    //'used externally to determine if statement valid
  public
     isOk          : Boolean;
    //1'available to caller to see key elements of what user typed
     Noun          : String;
     Verb          : String;
     Adjective     : String;
     Preposition   : String;
     Direction     : String;
     constructor Create;
     procedure ParseText(strWhat : String);

  protected
    //'internal lists
    const
//this is the power of Dot Net over Delphi..
//    ReadOnly lstVerbs : New List(Of String)({"be", "have", "do", "go", "get", "make", "know", "take", "see", "look", "give", "need", "put", "get", "let", "begin", "create", "start", "run", "move", "creep",
//                                             "hold", "use", "include", "set", "stop", "allow", "appear", "destroy", "kill", "disable", "enable", "open", "close", "run", "talk", "listen", "walk"})
//    ReadOnly lstNouns : New List(Of String)({"my", "you", "them", "they", "him", "she", "me", "their", "knife", "apple", "bread", "sword", "dragon", "knight", "key", "plate", "Candle", "matches", "door"})
//    ReadOnly lstAdjectives : New List(Of String)({"new", "old", "box", "first", "last", "current", "low", "high", "partial", "full", "common", "late", "early", "on", "used", "alert", "away", "forward", "backward",
//                                                  "left", "right"})
//    ReadOnly lstPrepositions : New List(Of String)({"in", "of", "with", "to", "behind", "when", "why", "while", "kind", "as", "by", "out", "under", "before", "up", "down", "between"})
//    ReadOnly lstDirections : New List(Of String)({"north", "south", "east", "west"})

    //'used when users types HELP LIST <verbs><nouns><adjectives><Prepositions><directions>
        lstHelpWords : Array of string =['Verbs', 'Nouns', 'Adjectives', 'Prepositions', 'Directions'];
    //'NOTE: the index of the position in the list is the SAME : the enumeration value
    //NOTE: because enum is not supported in Delphi using const instead!
        CNST_INT_VERBS = 0;
        CNST_INT_NOUNS = 1;
        CNST_INT_ADJECTIVES = 2;
        CNST_INT_PREPOSITIONS = 3;
        CNST_INT_DIRECTIONS = 4;


    procedure Help_ListValidWords(bytWhat : Byte);
    procedure Help_List();
    function ContainsValidWords(strWhat : String; bytWhat : Byte) : Boolean;
    function InStrRev(StrWhere: string; strWhat:string): integer;
  published

end;


implementation
uses
  System.SysUtils, System.StrUtils;

var
 lstVerbs        : TList<string>;      //as TList is not the same as List in Dot net
 lstNouns        : TList<string>;      //cannot delacre values at design time!
 lstAdjectives   : TList<string>;
 lstPrepositions : TList<string>;
 lstDirections   : TList<string>;
 //console vars
 coCoord         : TCOORD;
 hndConsole      : THandle;

    procedure ClrScr;
     {
      Created 25/07/2024 By Roger Williams

      Clears the screen as Delphi has facility to clear the console

      First benfit of Delphi over C#/VB/C++ can nest sub routines!

     }
    var
     intNum     : integer;
     strTemp    : string;

    begin
     //get console handlw and hope its this one as Delphi doers not give
     //the console a handle!
     hndConsole:=GetStdHandle(STD_OUTPUT_HANDLE);
     strTemp:=StringOfChar(' ',121);
     //Move the cursor home
     coCoord.X:=0;
     coCoord.Y:=0;
     SetConsoleCursorPosition(hndConsole, coCoord);
     SetConsoleTextAttribute(hndConsole, 31);
     //write blank lines
     for intNum:=0 to 42 do
      begin
       write(strTemp);
      end;

     //Move the cursor home
     coCoord.X:=0;
     coCoord.Y:=0;
     SetConsoleCursorPosition(hndConsole, coCoord);
    end;

  function TclsROGParser.InStrRev(strWhere:string; strWhat:string):integer;
{
      /*
          Created 25/07/2024 By Roger Williams

          Delphi does not have a inStrRev function sp created it!

          What It Does
          ============

          looks through a string from the RIGHT and finds the first instance of the string to look for
          and returns that position in the string

          VARS

          strWhere     : string to search
          strWhat      : string to look for
      */

  Needed a slight tweak as Delphi's "Contains" function is tempremental
  so worked around it
}
   var
      intNum       : integer;  //set to size of search string
      blnFound     : boolean;
      strCompare   : string;

   begin
   intNum := Length(strWhere)-1;
   blnFound:=false;
   strCompare:='';

      //look for first space
      while (intNum > 0) and (blnFound = false) do
      begin
        //strip string from end
        strCompare:=strWhere.Substring(intNum,1)+strCompare;

        if strCompare.IndexOf(strWhat) <> -1 then
        begin
          //set to exit
          blnFound:=true;
        end
      else
        Dec(intNum);
      end;

   result:= intNum;
  end;


    procedure TclsROGParser.Help_ListValidWords(bytWhat : Byte);
    {
        'Created 23/07/2024 By Roger Williams
        '
        'when users types: HELP LIST VERBS
        '
        'runs this sub which shows them on the console
        '
        'VARS
        '
        'bytWhat    : what to show (uses enum) 0=verb 1=noun
        '
        '
        '
    }
    var
        strOutput : String;
        strTemp   : String;
        intNum    : integer;

    begin
       intNum:=1;
       ClrScr;

       Case bytWhat of
          0: // 'verbs
          begin
                WriteLn('Valid Verbs');

                For strTemp In lstVerbs do
                begin
                    strOutput := strOutput + strTemp + ' ';
                    Inc(intNum); //intnum +=1 is dot net specific, so oironically used inc which is Delphi specific!

                    If intNum = 10 Then
                    begin
                        Writeln(strOutput);
                        strOutput := '';
                        intNum:=1;
                    end;
                end;
           end;
          1:  //'nouns
          begin
                Writeln('Valid Nouns');

                For strTemp In lstNouns do
                begin
                    strOutput := strOutput + strTemp + ' ';
                    Inc(intNum); //intnum +=1 is dot net specific, so oironically used inc which is Delphi specific!

                    If intNum = 10 Then
                    begin
                        Writeln(strOutput);
                        strOutput := '';
                        intNum:=1;
                    end;
                end;
          end;
          2: // 'adjectives
          begin
                Writeln('Valid Adjectives');

                For strTemp In lstVerbs do
                begin
                    strOutput := strOutput + strTemp + ' ';
                    Inc(intNum); //intnum +=1 is dot net specific, so oironically used inc which is Delphi specific!

                    If intNum = 10 Then
                    begin
                        Writeln(strOutput);
                        strOutput := '';
                        intNum:=1;
                    end;
                end;
          end;
          3:  //'prepositions
          begin
                Writeln('Valid Prepositions');

                For strTemp In lstPrepositions do
                begin
                    strOutput := strOutput + strTemp + ' ';
                    Inc(intNum); //intnum +=1 is dot net specific, so oironically used inc which is Delphi specific!

                    If intNum = 10 Then
                    begin
                        Writeln(strOutput);
                        strOutput := '';
                        intNum:=1;
                    end;
                end;
          end;
          4:  // 'directions
          begin
                Writeln('Valid Directions');

                For strTemp In lstDirections do
                begin
                    strOutput := strOutput + strTemp + ' ';
                    Inc(intNum); //intnum +=1 is dot net specific, so oironically used inc which is Delphi specific!

                    If intNum = 10 Then
                    begin
                        Writeln(strOutput);
                        strOutput := '';
                        intNum:=1;
                    end;
                end;
          end;
        end;

        if length(strOutput) <> 0 Then
           Writeln(strOutput);

        Writeln(' ');
    end;

    procedure TclsROGParser.Help_List();
{
        'Created 23/07/2024 By Roger Williams
        '
        'lists help options
        '
}
    begin
        ClrScr;
        //Move the cursor home
        coCoord.X:=0;
        coCoord.Y:=0;
        SetConsoleCursorPosition(hndConsole, coCoord);
        Writeln('Help Options');
        Writeln('============');
        Writeln('');
        Writeln('List available adjectives             - help list adjectives');
        Writeln('List available verbs                  - help list verbs');
        Writeln('List available nouns                  - help list nouns');
        Writeln('List available prepositions           - help list prepositions');
        Writeln('List available directions of movement - help list directions');
        Writeln('');
        Writeln('Enter: exit - at any time to end game');
        Writeln('');
    end;

    function TclsROGParser.ContainsValidWords(strWhat : String; bytWhat : Byte) : Boolean;
{
        'Created 23/07/2024 By Roger Williams
        '
        'checks if strPhrase contains verb,noun,adjective,preposition,direction
        '
        'VARS
        '
        'strWhat    : what to search
        'bytWhat    : what to check for (enum) verb,noun etc
        '
        'returns true if finds valid word
        'also populates public class vars:
        '
        'noun
        'verb
        'adjective
        'preposition
        'direction
        '
}
    var
        blnOK   : Boolean;
        strTemp : string;

    begin
    blnOk:=false;
        //'what to check
        Case bytWhat of
             0:  //'verbs
             begin
                For strTemp In lstVerbs do
                begin
                    If StrWhat.Contains(strTemp) Then
                    begin
                        Verb := strTemp;
                        blnOK := True;
                    end;
                end;
            end;
//'NOTE: above process copied for rest of the options
            1:  // 'nouns
            begin
                For strTemp In lstNouns do
                begin
                    If StrWhat.Contains(strTemp) Then
                    begin
                        Noun := strTemp;
                        blnOK := True;
                    end;
                end;
            end;
            2:  // 'adjectives
            begin
                For strTemp In lstAdjectives do
                begin
                    If StrWhat.Contains(strTemp) Then
                    begin
                        Adjective := strTemp;
                        blnOK := True;
                    end;
                end;
            end;
            3:  // 'prepositions
            begin
                For strTemp In lstPrepositions do
                begin
                    If StrWhat.Contains(strTemp) Then
                    begin
                        Preposition := strTemp;
                        blnOK := True;
                    end;
                end;
            end;
            4:  // 'directions
            begin
                For strTemp In lstDirections do
                begin
                    If StrWhat.Contains(strTemp) Then
                    begin
                        Direction := strTemp;
                        blnOK := True;
                    end;
                end;
            end;
        end;

        result:=blnOK;
    end;

    procedure TclsROGParser.ParseText(strWhat : String);
{
        'Created 23/07/2024 By Roger Williams
        '
        'checks if text contains valid words e.g. nouns sets IsOk accordingly
        '
        'Rules
        '-----
        '
        'every phase should contain a verb
        'every verb should either have an adjective e.g. open door
        'or
        'a preposition e.g. while
        'or
        'a noun e.g. key
        '
        'also handles user help requests, valid request string are:
        '
        'HELP
        '
        'HELP LIST
        ''         VERBS
        '          NOUNS
        '          ADJECTIVES
        '          PREPOSITIONS
        '          DIRECTIONS
        '
        '
}
    var
        bytValid : Byte;
        blnAdjective : Boolean ;
        blnDirection : Boolean ;
        blnNoun : Boolean ;
        blnPreposition : Boolean ;
        blnVerb : Boolean ;
        strTemp : String;

   begin
   isOk:=true; //reset

        If length(strWhat) = 0 Then
           begin
             isOk := False;
           end
        Else
            //'clear public vars
            Noun := '';
            Adjective := '';
            Verb := '';
            Preposition := '';
            Direction := '';

            //'convert to lowercase
            strWhat :=  strWhat.ToLower;
            //'check if help request
            If strWhat.IndexOf('help') <> -1 Then
            begin
                If strWhat = 'help' Then
                    Help_List();

                If (strWhat.Contains('help list')) Then
                begin
                    //get last word
                    strTemp := strWhat.Substring(InStrRev(strWhat, ' '), strWhat.Length - InStrRev(strWhat, ' '));
                    strTemp:=Trim(strTemp);

                    case IndexStr(strTemp,['verbs','adjectives','nouns','prepositions','directions']) of
                        0:  //Case 'verbs'
                            Help_ListValidWords(CNST_INT_VERBS);
                        1: //Case 'adjectives'
                            Help_ListValidWords(CNST_INT_ADJECTIVES);
                        2:  //Case 'nouns'
                            Help_ListValidWords(CNST_INT_NOUNS);
                        3: //Case 'prepositions'
                            Help_ListValidWords(CNST_INT_PREPOSITIONS);
                        4: //Case 'directions'
                            Help_ListValidWords(CNST_INT_DIRECTIONS);
                    else
                     begin
                       //'if not containing any valid words set to incorrect phrase
                       Writeln(strWhat + ' - Not Recognised Phrase');
                       isOk := False;
                     end;

                    end;
                end
            end
           else
{
                'every phase should contain a verb
                'every verb should either have an
                '
                'adjective e.g. open door
                'or
                'a preposition e.g. while
                'or
                'a noun e.g. key
                '
 }
             begin
                If ContainsValidWords(strWhat, CNST_INT_ADJECTIVES) Then blnAdjective := True;
                If ContainsValidWords(strWhat, CNST_INT_DIRECTIONS) Then blnDirection := True;
                If ContainsValidWords(strWhat, CNST_INT_NOUNS) Then blnNoun := True;
                If ContainsValidWords(strWhat, CNST_INT_PREPOSITIONS) Then blnPreposition := True;
                If ContainsValidWords(strWhat, CNST_INT_VERBS) Then blnVerb := True;

                //'mow look at the rules
                If blnVerb Then bytValid:= 1;
                If blnAdjective And blnVerb Then Inc(bytValid);
                If blnPreposition And blnVerb Then Inc(bytValid);
                If blnNoun And blnVerb Then Inc(bytValid);

                If (bytValid > 0) or (Noun='exit') Then
                    isOk := True
                Else
                   begin
                    //'if not containing any valid words set to incorrect phrase
                    Writeln(strWhat + ' - Not Recognised Phrase');
                    isOk := False;
                   end;
             end;
    end;

    constructor TclsROGParser.Create;
    begin
       isOk          :=true;
       //1'available to caller to see key elements of what user typed
       Noun          :='';;
       Verb          :='';;
       Adjective     :='';;
       Preposition   :='';;
       Direction     :='';
       //create lists as Delphi does not support TList as in dot net
      lstVerbs:=TList<string>.Create;
      lstNouns:=TList<string>.Create;
      lstAdjectives:=TList<string>.Create;
      lstPrepositions:=Tlist<string>.Create;
      lstDirections:=TList<string>.Create;
      //forced to populate the lists at runtime!
      lstverbs.AddRange(['be', 'have', 'do', 'go', 'get', 'make', 'know', 'take', 'see', 'look', 'give', 'need', 'put', 'get', 'let', 'begin', 'create', 'start', 'run', 'move', 'creep',
                         'hold', 'use', 'include', 'set', 'stop', 'allow', 'appear', 'destroy', 'kill', 'disable', 'enable', 'open', 'close', 'run', 'talk', 'listen', 'walk']);
      lstNouns.AddRange(['exit','my', 'you', 'them', 'they', 'him', 'she', 'me', 'their', 'knife', 'apple', 'bread', 'sword', 'dragon', 'knight', 'key', 'plate', 'cnadle', 'matches', 'door']);
      lstAdjectives.AddRange(['new', 'old', 'box', 'first', 'last', 'current', 'low', 'high', 'partial', 'full', 'common', 'late', 'early', 'on', 'used', 'alert', 'away', 'forward', 'backward',
                             'left', 'right']);
      lstPrepositions.AddRange(['in', 'of', 'with', 'to', 'behind', 'when', 'why', 'while', 'kind', 'by', 'under', 'before', 'up', 'down', 'between']);
      lstDirections.AddRange(['north', 'south', 'east', 'west']);
    end;
end.
