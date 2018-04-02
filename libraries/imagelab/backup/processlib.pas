unit ProcessLib;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, BGRABitmap, BGRABitmapTypes, bgraimageprocess, ExtCtrls, Graphics;

type
	TProcessThread = class(TThread)
    	Input : TBGRABitmap;
    	Output : ^TBGRABitmap;
        fm: single;
    	first : Integer;
    	last: Integer;
        pImage : ^TImage;
    private
    	fStatusText : string;
      	procedure ShowStatus;
    protected
      	procedure Execute; override;
    public
    	Constructor Create(CreateSuspended : boolean);
        function GetPercentage : Single;
    end;

implementation

constructor TProcessThread.Create(CreateSuspended : boolean);
  begin
    inherited Create(CreateSuspended); // because this is black box in OOP and can reset inherited to the opposite again...
    //FreeOnTerminate := True;  // better code...
  end;

  procedure TProcessThread.ShowStatus;
  // this method is executed by the mainthread and can therefore access all GUI elements.
  begin
    //Form1.Caption := fStatusText;
  end;

  procedure TProcessThread.Execute;
  var
    newStatus : string;
  begin
    fStatusText := 'TMyThread Starting...';
    Synchronize(@Showstatus);
    fStatusText := 'TMyThread Running...';
    //while (not Terminated)  {and ([any condition required]) } do
    BGRABicubicPolyrama7(Input, Output, fm, first, last);
    //    if NewStatus <> fStatusText then
    //      begin
    //        fStatusText := newStatus;
    //        Synchronize(@Showstatus);
    //      end;
    //  end;
    Input.Free;
  end;

  function TProcessThread.GetPercentage : Single;
  var
    s : Single;
  begin
       s := percent;
       result := s;
  end;

end.

