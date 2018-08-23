import os
import os.path as path
import re
import pyparsing
from collections import deque
from verilogParse import parse, module_hier

identifier = r"([a-zA-Z_][\$\w]*)"
module_regex = r"module\s+" + identifier + r"\s*[(](.*?)[)]\s*;\s*(.*?)endmodule"
list_of_module_connections = r".*?"
module_instance = identifier + r"\s*[(]\s*(" + list_of_module_connections + r")?\s*[)]"
module_inst_regex = r"^\s*" + identifier + r"\s*(#\s*[(](.*?)[)]\s*)?" + module_instance + r"\s*" + r"(,\s*" + module_instance + r"\s*)*;\s*$"
re_module = re.compile(module_regex, re.S)
re_module_inst = re.compile(module_inst_regex, re.M | re.S)

def pre(s):
    docu_regex = r"//(.*?)$"
    re_docu = re.compile(docu_regex, re.M)
    s = re_docu.sub("", s)
    macro_regex = r"^\s*`(include|ifdef|ifndef|else|endif|define)(.*?)$"
    re_macro = re.compile(macro_regex, re.M)
    s = re_macro.sub("", s)
    mcr_sub_regex = r"`" + identifier
    re_mcr_sub = re.compile(mcr_sub_regex, re.M)
    s = re_mcr_sub.sub("1", s)
    # print(s)
    return s

def verilator_preprocess(src, headers):
    exe = "verilator "
    flags = "-E -P "
    include = set()
    for header in headers:
        include.add(path.split(header)[0])
    for p in include:
        flags += "-I" + p + " "
    cmd = exe + flags + src
    # print(cmd)
    res = os.popen(cmd).read()
    print(res)
    # exit()
    return res

def do_scan(buff):
    # print(module_regex)
    # buff = pre(buff)
    # module_res = re_module.findall(buff) 
    module_res = parse(buff)
    return module_res

def scan_file(p: str, headers):
    # dir_name, file_name = paht.split(path)
    print("Parse file", p)
    buff = verilator_preprocess(p, headers)
    # buff = open(p).read()
    res = do_scan(buff)
    # print(res)
    return (p, res)

def test_scan(path):
    res = scan_file(path, [])
    print(res)
    return res

if __name__ == "__main__":
    test_scan("test.v") 

