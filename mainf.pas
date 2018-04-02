unit mainF;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ExtCtrls, ExtDlgs, ImageProcess;

type

  { TMainForm }

  TMainForm = class(TForm)
    Image: TImage;
    MainMenu: TMainMenu;
    FileMenuItem: TMenuItem;
    MagnifyMenuItem: TMenuItem;
    SaveMenuItem: TMenuItem;
    PolyramaMenuItem: TMenuItem;
    ProcessMenuItem: TMenuItem;
    OpenMenuItem: TMenuItem;
    CloseMenuItem: TMenuItem;
    OpenPictureDialog: TOpenPictureDialog;
    SavePictureDialog: TSavePictureDialog;
    ScrollBox: TScrollBox;
    Timer: TTimer;
    procedure CloseMenuItemClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImageMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure ImageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure OpenMenuItemClick(Sender: TObject);
    procedure PolyramaMenuItemClick(Sender: TObject);
    procedure SaveMenuItemClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
     mouseIsDown : Boolean;
     startDragX : Integer;
     startDragY : Integer;
     count : Integer;
     imProcess : TImageProcess;
  public

  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.FormCreate(Sender: TObject);
begin
     ScrollBox.Align := alClient;
     ScrollBox.HorzScrollBar.Tracking := true;
     ScrollBox.VertScrollBar.Tracking := true;
     mouseIsDown := false;
     count := 0;
     imProcess := TImageProcess.Create;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
     imProcess.Destroy;
end;

procedure TMainForm.CloseMenuItemClick(Sender: TObject);
begin
     Close;
end;

procedure TMainForm.ImageMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
     mouseIsDown := true;
     startDragX := X;
     startDragY := Y;
     Image.Cursor := crHandPoint;
end;

procedure TMainForm.ImageMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
	distanceX : Integer;
	distanceY : Integer;
begin
	if (mouseIsDown = true) then
	begin
    	distanceX := startDragX - X;
    	distanceY := startDragY - Y;
    	ScrollBox.HorzScrollBar.Position := ScrollBox.HorzScrollBar.Position + distanceX;
    	ScrollBox.VertScrollBar.Position := ScrollBox.VertScrollBar.Position + distanceY;
  	end;
end;

procedure TMainForm.ImageMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
     mouseIsDown := false;
     Image.Cursor := crDefault;
end;

procedure TMainForm.OpenMenuItemClick(Sender: TObject);
var
	pic : TPicture;
begin
     if (OpenPictureDialog.Execute) then
     begin
          pic := TPicture.Create;
          pic.LoadFromFile(OpenPictureDialog.FileName);
          Image.Picture.Bitmap.SetSize(pic.Width, pic.Height);
          Image.Picture.Bitmap.Canvas.Draw(0, 0, pic.Bitmap);
          Image.Width := pic.Width;
          Image.Height := pic.Height;
          ScrollBox.HorzScrollBar.Position := 0;
          ScrollBox.VertScrollBar.Position := 0;
          pic.Free;
          mainForm.Caption := 'Clear';
     end;
end;

procedure TMainForm.SaveMenuItemClick(Sender: TObject);
begin
     if (SavePictureDialog.Execute) then
     begin
          Image.Picture.SaveToFile(SavePictureDialog.FileName);
     end;
end;

procedure TMainForm.TimerTimer(Sender: TObject);
begin
  Caption:=IntToStr(Round(imProcess.GetProgess));
end;

procedure TMainForm.PolyramaMenuItemClick(Sender: TObject);
var
    fm : Single;
    finalWidth, finalHeight : Integer;
begin
    //MagniFyFactorForm.ShowModal;
    fm := 5;
    finalWidth := round (Image.Picture.Bitmap.Width * fm);
    finalHeight := round (Image.Picture.Bitmap.Height * fm);
    imProcess.Magnify(@Image, fm);
    ScrollBox.HorzScrollBar.Position := 0;
    ScrollBox.VertScrollBar.Position := 0;
end;

end.

