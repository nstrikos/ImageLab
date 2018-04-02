unit ImageProcess;

{$mode objfpc}{$H+}

interface

uses
  Classes, ExtCtrls, ProcessThread, BGRABitmap, UTF8Process;

type
    PointerImage = ^TImage;
type
    {TImageProcess}
    TImageProcess = class
        destructor Destroy;
    public
        constructor Create;
    	procedure Magnify(p: PointerImage; fm : Single);
        function GetProgess : Single;
    private
        pImage : PointerImage;
        inBitmap : TBGRABitmap;
        outBitmap: TBGRABitmap;
        Threads: array of TProcessThread;
        numberThreads, count : Integer;
        procedure OnThreadDone(ASender : TObject);
    end;

implementation

constructor TImageProcess.Create;
var
  i: Integer;
begin
    numberThreads := GetSystemThreadCount;
    writeln('Number of CPUs : ', numberThreads);
    SetLength(Threads, numberThreads);
end;

destructor TImageProcess.Destroy;
var
  i : Integer;
begin
     for i := 0 to numberThreads - 1 do
         Threads[i].Free;
end;

procedure TImageProcess.Magnify(p: PointerImage; fm : Single);
var
  rect : TRect;
  i : Integer;
  height : Integer;
begin

     for i := 0 to numberThreads - 1 do
     begin
          Threads[i].Free;
          Threads[i] := TProcessThread.Create(True);
     end;

     pImage := p;
     count := 0;

     outBitmap := TBGRABitmap.Create( Round(pImage^.Width * fm), Round(pImage^.Height * fm) );
     rect := TRect.Create(0, 0, pImage^.Width, pImage^.Height);
     height := outBitmap.Height div numberThreads;

     for i := 0 to numberThreads - 1 do
     begin
          Threads[i].Input := TBGRABitmap.Create(pImage^.Width, pImage^.Height);
          Threads[i].Input.Canvas.CopyRect(rect, pImage^.Picture.Bitmap.Canvas, rect);
          Threads[i].pImage:=pImage;
          Threads[i].Output := @outBitmap;
          Threads[i].fm := fm;
          if ( i = 0 ) then
          begin
               Threads[i].first := 0;
               Threads[i].last := height;
          end
          else
          begin
               Threads[i].first := Threads[i-1].last;
               Threads[i].last :=  Threads[i].first + height;
          end;
          Threads[i].OnTerminate := @OnThreadDone;
          Threads[i].Start;
     end;
end;

procedure TImageProcess.OnThreadDone(ASender : TObject);
var
  i : Integer;
begin
    count := count + 1;
    if (count = numberThreads - 1) then
    begin
    	pImage^.Picture.Bitmap.Assign(outBitmap);
    	pImage^.Picture.Bitmap.Width := outBitmap.Width;
    	pImage^.Picture.Bitmap.Height := outBitmap.Height;
    	pImage^.Width := outBitmap.Width;
    	pImage^.Height := outBitmap.Height;
    	inBitmap.Free;
    	outBitmap.Free;
    end;
end;

function TImageProcess.GetProgess : Single;
begin
    result := Threads[0].GetPercentage;
end;

end.




