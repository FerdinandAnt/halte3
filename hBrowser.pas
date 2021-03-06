unit hBrowser;

interface

function BrowseForFolder(const browseTitle: String;
  const initialFolder: String = ''): String;

implementation

uses Windows, shlobj;

var
  lg_StartFolder: String;

  /// ////////////////////////////////////////////////////////////////
  // Call back function used to set the initial browse directory.
  /// ////////////////////////////////////////////////////////////////
function BrowseForFolderCallBack(Wnd: HWND; uMsg: UINT; lParam, lpData: lParam)
  : Integer stdcall;
begin
  if uMsg = BFFM_INITIALIZED then
    SendMessage(Wnd, BFFM_SETSELECTION, 1, Integer(@lg_StartFolder[1]));
  result := 0;
end;

// Arguments:-
// browseTitle : The title to display on the browse dialog.
// initialFolder : Optional argument. Use to specify the folder
// initially selected when the dialog opens.
//
// Returns: The empty string if no folder was selected ( i.e. if the
// user clicked cancel), otherwise the full folder path.

function BrowseForFolder(const browseTitle: String;
  const initialFolder: String = ''): String;
const
  BIF_NEWDIALOGSTYLE = $40;
var
  browse_info: TBrowseInfo;
  folder: array [0 .. MAX_PATH] of char;
  find_context: PItemIDList;
begin
  FillChar(browse_info, SizeOf(browse_info), #0);
  lg_StartFolder := initialFolder;
  browse_info.pszDisplayName := @folder[0];
  browse_info.lpszTitle := PChar(browseTitle);
  browse_info.ulFlags := BIF_RETURNONLYFSDIRS or BIF_NEWDIALOGSTYLE;
  if initialFolder <> '' then
    browse_info.lpfn := BrowseForFolderCallBack;
  find_context := SHBrowseForFolder(browse_info);
  if Assigned(find_context) then
  begin
    if SHGetPathFromIDList(find_context, folder) then
      result := folder
    else
      result := '';
    GlobalFreePtr(find_context);
  end
  else
    result := '';
end;

end.
