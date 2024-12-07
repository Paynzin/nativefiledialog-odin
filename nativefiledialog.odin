package nativefiledialog

when ODIN_OS == .Windows {
	@(extra_linker_flags="/NODEFAULTLIB:" + ("libcmt"))
	foreign import lib {
		"windows/nativefiledialog.lib",
		"system:Winmm.lib",
		"system:kernel32.lib",
		"system:Ole32.lib",
		"system:Shell32.lib",
	}
} else when ODIN_OS == .Linux  {
	foreign import lib {
		"linux/libnativefiledialog.a",
		"system:dl",
		"system:pthread",
	}
}

when ODIN_OS == .Windows {
	Path_Set_Size :: distinct u64

	Path_Set :: struct {
		ptr: rawptr,
	}
} else when ODIN_OS == .Linux {
	Path_Set_Size :: distinct u32

	Path_Set :: struct {
		d1: rawptr,
		d2: rawptr,
		d3: u32,
		d4: i32,
		d5: i32,
		d6: i32,
		d7: i32,
		d8: i32,
		d9: i32,
		d10: i32,
		d11: i32,
		p1: i32,
		p2: rawptr,
		p3: rawptr,
	}
}

Result :: enum {
	Error,
	Okay,
	Cancel,
}

Filter_Size :: distinct u32

Filter_Item :: struct {
	name: cstring,
	spec: cstring,
}

Window_Handle_Type :: enum {
	Unset = 0,
	Windows = 1,
	Cocoa = 2,
	X11 = 3,
}

Window_Handle :: struct {
	type: Window_Handle_Type,
	handle: rawptr,
}

Version :: distinct int

Open_Dialog_Args :: struct {
	filter_list: Filter_Item,
	filter_count: Filter_Size,
	default_path: cstring,
	parent_window: Window_Handle,
}

Save_Dialog_Args :: struct {
	filter_list: Filter_Item,
	filter_count: Filter_Size,
	default_path: cstring,
	default_name: cstring,
	parent_window: Window_Handle,
}

Pick_Folder_Args :: struct {
	default_path: cstring,
	parent_window: Window_Handle,
}

@(default_calling_convention="c", link_prefix="NFD_")
foreign lib {
	FreePathN :: proc(file_path: cstring) ---
	FreePathU8 :: proc(file_path: cstring) ---
	
	Init :: proc() ---
	Quit :: proc() ---
	
	OpenDialogN :: proc(out_path: ^cstring, filter_list: [^]Filter_Item, filter_count: Filter_Size, default_path: cstring) -> Result ---
	OpenDialogU8 :: proc(out_path: ^cstring, filter_list: [^]Filter_Item, filter_count: Filter_Size, default_path: cstring) -> Result ---
	OpenDialogN_With :: proc(out_path: ^cstring, args: ^Open_Dialog_Args) -> Result --- // check later
	OpenDialogU8_With :: proc(out_path: ^cstring, args: ^Open_Dialog_Args) -> Result --- // check later
	OpenDialogMultipleN :: proc(out_paths: [^]cstring, filter_list: [^]Filter_Item, filter_count: Filter_Size, default_path: cstring) -> Result ---
	OpenDialogMultipleN_With :: proc(out_paths: [^]cstring, args: ^Open_Dialog_Args) -> Result --- // check later
	OpenDialogMultipleU8_With :: proc(out_paths: [^]cstring, args: Filter_Size) -> Result --- // check later
	
	SaveDialogN :: proc(out_path: ^cstring, filter_list: [^]Filter_Item, filter_count: Filter_Size, default_path: cstring, default_name: cstring) -> Result ---
	SaveDialogU8 :: proc(out_path: ^cstring, filter_list: [^]Filter_Item, filter_count: Filter_Size, default_path: cstring, default_name: cstring) -> Result ---
	SaveDialogN_With :: proc(out_path: ^cstring, args: ^Save_Dialog_Args) -> Result ---
	SaveDialogU8_With :: proc(out_path: ^cstring, args: ^Save_Dialog_Args) -> Result ---
	
	PickFolderN :: proc(out_path: ^cstring, default_path: cstring) -> Result ---
	PickFolderU8 :: proc(out_path: ^cstring, default_path: cstring) -> Result ---
	PickFolderN_With :: proc(out_path: ^cstring, args: ^Pick_Folder_Args) -> Result --- // check later
	PickFolderU8_With :: proc(out_path: ^cstring, args: ^Pick_Folder_Args) -> Result --- // check later
	PickFolderMultipleN :: proc(out_path: ^cstring, default_path: cstring) -> Result --- // check later
	PickFolderMultipleU8 :: proc(out_path: [^]cstring, default_path: cstring) -> Result ---
	PickFolderMultipleN_With :: proc(out_path: [^]cstring, args: ^Pick_Folder_Args) -> Result --- // check later
	PickFolderMultipleU8_With :: proc(out_paths: [^]cstring, args: ^Pick_Folder_Args) -> Result --- // check later
	
	PathSet_GetCount :: proc(path_set: ^Path_Set, count: ^Path_Set_Size) -> Result ---
	PathSet_GetPathN :: proc(path_set: ^Path_Set, index: Path_Set_Size, outpath: ^cstring) -> Result ---
	PathSet_GetPathU8 :: proc(path_set: ^Path_Set, index: Path_Set_Size, outpath: ^cstring) -> Result ---
	PathSet_FreePathN :: proc(file_path: cstring) ---
	PathSet_FreePathU8 :: proc(file_path: cstring) ---
	PathSet_GetEnum :: proc(path_set: ^Path_Set, out_enumerator: rawptr) ---
	PathSet_FreeEnum :: proc(enumerator: rawptr) ---
	PathSet_EnumNextN :: proc(enumerator: rawptr, out_path: ^cstring) ---
	PathSet_EnumNextU8 :: proc(enumerator: rawptr, out_path: ^cstring) ---
	PathSet_Free :: proc(path_set: ^Path_Set) ---
	
	GetError :: proc() -> cstring ---
	ClearError :: proc() ---
}