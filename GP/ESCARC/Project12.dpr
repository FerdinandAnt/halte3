program Project12;

{$APPTYPE CONSOLE}

{$R *.res}


uses
  System.SysUtils,
  System.Classes;

type
  THead = packed record
    magic: array [ 0 .. 7 ] of ansichar;
    constrs: Cardinal;
  end;

  TDataHead = packed record
    magic: Cardinal;
    datasize: Cardinal;
  end;

  TListHead = packed record
    offset: Cardinal;
    indexs: Cardinal;
  end;

  NAME_T = packed record
    text: array [ 0 .. 63 ] of ansichar;
    color: Cardinal;
    face: array [ 0 .. 31 ] of ansichar;
  end;

  VAR_T = packed record
    name: array [ 0 .. 31 ] of ansichar;
    index: Word;
    flag: Word;
  end;

  SCENE_T = packed record
    script: Cardinal;
    title: array [ 0 .. 63 ] of ansichar;
    thumbnail: array [ 0 .. 31 ] of ansichar;
    order: Cardinal;
  end;

  BG_T = packed record
    name: array [ 0 .. 31 ] of ansichar;
    color: Cardinal;
    order: Cardinal;
    link: Cardinal;
  end;

  EV_T = packed record
    name: array [ 0 .. 31 ] of ansichar;
    color: Cardinal;
    order: Cardinal;
    link: Cardinal;
  end;

  ST_T = packed record
    name: array [ 0 .. 31 ] of ansichar;
    base: array [ 0 .. 31 ] of ansichar;
    option: array [ 0 .. 63 ] of ansichar;
    pose: Cardinal;
    order: Cardinal;
    link: Cardinal;
  end;

  EM_T = packed record
    _file: array [ 0 .. 31 ] of ansichar;
    x: Integer;
    y: Integer;
    loop: Cardinal;
    pose: Cardinal;
    id: Cardinal;
  end;

  EFX_T = packed record
    _file: array [ 0 .. 31 ] of ansichar;
    x: Integer;
    y: Integer;
    loop: Cardinal;
  end;

  BGM_T = packed record
    name: array [ 0 .. 63 ] of ansichar;
    _file: array [ 0 .. 63 ] of ansichar;
    title: array [ 0 .. 63 ] of ansichar;
    order: Cardinal;
  end;

  AMB_T = packed record
    name: array [ 0 .. 63 ] of ansichar;
    _file: array [ 0 .. 63 ] of ansichar;
  end;

  SE_T = packed record
    name: array [ 0 .. 63 ] of ansichar;
    _file: array [ 0 .. 63 ] of ansichar;
  end;

  SFX_T = packed record
    name: array [ 0 .. 63 ] of ansichar;
    _file: array [ 0 .. 63 ] of ansichar;
  end;

  // konosora.h
  // ���j�b�g
typedef struct {
  uchar	name[32];						// ���O
  int		parent;							// �e���j�b�g
  int		kind;							// ����
  int		cg;								// �摜�ԍ�
  int		voice;							// �����ԍ�
  int		ability[ABI_MAX];				// �\�͒l
  int		growth[ABI_MAX];				// ������
  int		resist[RES_MAX];				// �ϐ�
  int		skill[ENEMY_SKILL_MAX];			// �G�X�L��
} UNIT_T;

// �������j
typedef struct {
  int		ability[ABI_MAX];				// �\�͐�����
} POLICY_T;

// �l���o���l�e�[�u��
typedef struct {
  int		point;							// �\�̓|�C���g
  int		kegare[3];						// �P�K���o����
} EXP_T;

// �K���\�̓e�[�u��
typedef struct {
  int		s_char;							// �L�����N�^�[
  int		stat;							// �X�e�[�^�X
  int		para;							// ���B�|�C���g
  int		skill[3];						// ����\��
} GETSKILL_T;

// �A�N�e�B�u�X�L��
typedef struct {
  uchar	name[32];						// �X�L����
  int		level;							// �X�L��LV
  int		special;						// ���`
  int		kind;							// ���
  int		range;							// �͈�
  int		hit_rate;						// ������
  int		element;						// ����
  int		power;							// �З�
  int		turn;							// ���ʃ^�[��
  int		extra;							// �ǉ�����
  int		effect;							// �G�t�F�N�g
  int		point;							// �K�v�|�C���g
  uchar	help[256];						// ����
} ASKILL_T;

// �p�b�V�u�X�L��
typedef struct {
  uchar	name[32];						// ���O
  int		ability[ABI_MAX];				// �t���\�͒l
  int		resistance[RES_MAX];			// �t���ϐ��l
  int		extra;							// ���̑�
  int		power;							// �З�
  int		point;							// �K�v�|�C���g
  uchar	help[256];						// ����
} PSKILL_T;

// �G�t�F�N�g
typedef struct {
  struct{
  uchar	file[32];					// �t�@�C����
  int		x, y;						// �Œ���W
  int		scale;						// �g�嗦
  uint	time;						// ��e����
} shot[ 2 ];
struct {
  uchar	file[32];					// �t�@�C����
  int		x, y;						// �Œ���W
  int		scale;						// �g�嗦
} hit[ 2 ];
int hit_count; // �q�b�g��
} EFFECT_T;

// �G���
typedef struct {
  int		unit;							// ���j�b�g
  int		level;							// ���x��
  int		x, y;							// �\���ʒu
} ENEMY_INFO;

// �퓬�X�e�[�W
typedef struct {
  ENEMY_INFO	enemy[ENEMY_MAX];			// �G���
  uchar		bgm_file[32];				// BGM
  uchar		bg_file[2][32];				// �w�i
  int			bg_line;					// �w�i�̒n�ʍ��W
  int			script;						// �퓬�X�N���v�g
} STAGE_T;

// �퓬�X�N���v�g
typedef struct {
  uchar	file[32];						// �t�@�C����
} BSCRIPT_T;

// �N�G�X�g
typedef struct {
  uchar	name[32];						// �N�G�X�g��
  int		kind;							// �N�G�X�g�̎��
  int		h_flag;							// H�t���O
  int		place;							// �ꏊ
  int		time;							// ���ԑ�
  int		battle;							// �퓬�X�e�[�W
  int		active_skill;					// ����A�N�e�B�u�X�L��
  int		passive_skill;					// ����p�b�V�u�X�L��
  int		limit;							// ����
  uchar	script[32];						// �X�N���v�g
  uchar	help[256];						// ����
} QUEST_T;

// �ꏊ
typedef struct {
  uchar	name[32];						// �ꏊ��
  int		x, y;							// �}�b�v���W
  uchar	bg_file[3][32];					// �w�i�摜
} PLACE_T;

const
  fullSizeCharacter: Array [ 0 .. 63 ] of char = (
    '��', '��', '��', '��', '��',
    '��', '��', '��', '��', '��', '�[', '��', '��', '��', '��',
    '��', '��', '��', '��', '��', '��', '��', '��', '��', '��',
    '��', '��', '��', '��', '��', '��', '��', '��', '��', '��',
    '��', '��', '��', '��', '��', '��', '��', '��', '��', '��',
    '��', '��', '��', '��', '��', '��', '��', '��', '��', '��',
    '��', '�c', '�@', '�I', '�H', '�B', '�u', '�v', '�A'
    );
  halfSizeCharacter: Array [ 0 .. 63 ] of char = (
    '�', '�', '�', '�', '�',
    '�', '�', '�', '�', '�', '�', '�', '�', '�', '�',
    '�', '�', '�', '�', '�', '�', '�', '�', '�', '�',
    '�', '�', '�', '�', '�', '�', '�', '�', '�', '�',
    '�', '�', '�', '�', '�', '�', '�', '�', '�', '�',
    '�', '�', '�', '�', '�', '�', '�', '�', '�', '�',
    '�', '�', #$a0, '!', '?', '�', '�', '�', '�'
    );

procedure ReadList(var p: Pointer; size: Cardinal; buf: TStream);
var
  head: TListHead;
begin
  buf.Read(head.offset, SizeOf(TListHead));
  p := SysGetMem(head.indexs * size);
  buf.Seek(head.offset, soFromCurrent);
  buf.Read(p^, head.indexs * size);
end;

function Searchhalf(c: char): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I  := 0 to 62 do
  begin
    if c = halfSizeCharacter[ I ] then
    begin
      Result := I;
      Break;
    end;
  end;
end;

function SearchFull(c: char): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I  := 0 to 62 do
  begin
    if c = fullSizeCharacter[ I ] then
    begin
      Result := I;
      Break;
    end;
  end;
end;

function KATAStrToFullSizeHURI(AStr: string): string;
var
  I: Integer;
begin
  Result := '';
  for I  := 1 to Length(AStr) do
  begin
    StringReplace(AStr, '�', '\n', [ rfReplaceAll ]);
    if Searchhalf(AStr[ I ]) <> -1 then
      Result := Result + fullSizeCharacter[ Searchhalf(AStr[ I ]) ]
    else
      Result := Result + AStr[ I ];
  end;
end;

var
  Bin, Bin2 : TMemoryStream;
  text      : TStringList;
  head      : THead;
  Table     : array of Cardinal;
  ParamTable: Cardinal;
  StrTable  : Cardinal;
  I         : Integer;
  Str       : AnsiString;
  StrBuf    : TMemoryStream;
  Zero      : Byte;

begin
  try
    if ParamCount <> 3 then
      raise Exception.Create('Error');
    SetMultiByteConversionCodePage(StrToInt(ParamStr(3)));
    Bin  := TMemoryStream.Create;
    text := TStringList.Create;
    if StrToInt(ParamStr(2)) = 1 then
    begin
      Bin.LoadFromFile(ParamStr(1));
      Bin.Seek(0, soFromBeginning);
      Bin.Read(head.magic[ 0 ], SizeOf(THead));
      if not SameText('ESCR1_00', Trim(head.magic)) then
        raise Exception.Create('magic');
      SetLength(Table, head.constrs + 1);
      Bin.Read(Table[ 0 ], head.constrs * 4);
      Bin.Read(ParamTable, 4);
      Bin.Seek(ParamTable, soFromCurrent);
      Bin.Read(StrTable, 4);
      Table[ head.constrs ] := StrTable;
      for I                 := Low(Table) to High(Table) - 1 do
      begin
        SetLength(Str, Table[ I + 1 ] - Table[ I ]);
        Bin.Read(Pbyte(Str)^, Table[ I + 1 ] - Table[ I ]);
        text.Add(KATAStrToFullSizeHURI(Trim(Str)));
      end;
      text.SaveToFile(ChangeFileExt(ParamStr(1), '.txt'), TEncoding.UTF8);
    end else if StrToInt(ParamStr(2)) = 2 then
    begin
      StrBuf := TMemoryStream.Create;
      if ExtractFileExt(ParamStr(1)) <> '.txt' then
        raise Exception.Create('Error');
      text.LoadFromFile(ParamStr(1), TEncoding.UTF8);
      if not FileExists(ChangeFileExt(ParamStr(1), '.bin')) then
      begin
        raise Exception.Create('BIN');
      end;
      SetLength(Table, text.Count + 1);
      Table[ 0 ] := 0;
      Zero       := 0;
      for I      := 0 to text.Count - 1 do
      begin
        Str            := text[ I ];
        Table[ I + 1 ] := Table[ I ] + Length(Str) + 1;
        StrBuf.Write(Pbyte(Str)^, Length(Str));
        StrBuf.Write(Zero, 1);
      end;
      Str := 'ESCR1_00';
      Bin.Write(Pbyte(Str)^, 8);
      StrTable := text.Count;
      Bin.Write(StrTable, 4);
      Bin.Write(Table[ 0 ], text.Count * 4);
      Bin2 := TMemoryStream.Create;
      Bin2.LoadFromFile(ChangeFileExt(ParamStr(1), '.bin'));
      Bin2.Seek(0, soFromBeginning);
      Bin2.Read(head.magic[ 0 ], SizeOf(THead));
      Bin2.Seek(head.constrs * 4, soFromCurrent);
      Bin2.Read(ParamTable, 4);
      Bin.Write(ParamTable, 4);
      Bin.CopyFrom(Bin2, ParamTable);
      Bin2.Free;
      Bin.Write(Table[ text.Count ], 4);
      StrBuf.Seek(0, soFromBeginning);
      Bin.CopyFrom(StrBuf, StrBuf.size);
      Bin.SaveToFile(ChangeFileExt(ParamStr(1), '.bin'));
      StrBuf.Free;
    end else if StrToInt(ParamStr(2)) = 3 then
    begin

    end else if StrToInt(ParamStr(2)) = 4 then
    begin

    end else if StrToInt(ParamStr(2)) = 5 then
    begin

    end;
    Bin.Free;
    text.Free;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.
