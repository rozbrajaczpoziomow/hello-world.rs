use std::{fs, env, path::PathBuf};

use aho_corasick::AhoCorasick;

fn main() {
    println!("cargo:rerun-if-changed=hello-world.rs.rc");
    println!("cargo:rerun-if-changed=hello-world.rs.exe.manifest");
    if env::var("CARGO_CFG_TARGET_FAMILY").unwrap() == "windows" {
        let manifest_template = fs::read_to_string("hello-world.rs.exe.manifest").unwrap();
        let arch = match &*env::var("CARGO_CFG_TARGET_ARCH").unwrap() {
            "x86" => "x86",
            "x86_64" => "amd64",
            "arm" => "arm",
            "aarch64" => "arm64",
            _ => "",
        };
        let mut version = env::var("CARGO_PKG_VERSION").unwrap();
        let last_dot = version.rfind(".").unwrap();
        version.insert_str(last_dot, ".0"); // windows style
        let with_commas = version.replace(".", ",");
        let debug_mode = env::var("DEBUG").unwrap();
        let matcher = AhoCorasick::new(["__VERSION__", "__VERSION_WITH_COMMAS__", "__ARCHITECTURE__", "__DEBUG__"]);
        let replacements = [&version, &with_commas, arch, &debug_mode];
        let modified_manifest = matcher.replace_all(&manifest_template, &replacements);
        let rc_template = fs::read_to_string("hello-world.rs.rc").unwrap();
        let modified_rc = matcher.replace_all(&rc_template, &replacements);
        let out_dir = PathBuf::from(env::var_os("OUT_DIR").unwrap());
        fs::write(out_dir.join("hello-world.rs.exe.manifest"), modified_manifest).unwrap();
        fs::write(out_dir.join("hello-world.rs.rc"), modified_rc).unwrap();
        env::set_current_dir(out_dir).unwrap();
        embed_resource::compile("hello-world.rs.rc");
    }
    // env::set_current_dir(env::var_os("CARGO_MANIFEST_DIR").unwrap()).unwrap();
}
