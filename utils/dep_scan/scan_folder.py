#!/usr/bin/python3
import os
import os.path as path
import argparse
from scan_file import scan_file
from collections import deque
from multiprocessing import Pool
from itertools import repeat


def find_files(folder):
    srcs = []
    headers = []
    for root, dirnames, filenames in os.walk(folder):
        for filename in filenames:
            filepath = path.join(root, filename)
            # print('scanning ' + filepath)
            ext = path.splitext(filepath)[1]
            # print(ext)
            if ext == '.v' or ext == '.vlib':
                srcs.append(filepath)
            elif ext == '.vh':
                headers.append(filepath)
    return srcs, headers

def scan_file_helper(filepath, headers):
    r = (filepath, dict())
    try:
        r = scan_file(filepath, headers)
    except Exception:
        pass
    return r

def scan_folder(folder, args):
    srcs, headers = find_files(folder)
    # print(srcs)
    file_module = []
    if args.parallel == 1:
        for filepath in srcs:
            try:
                print("Parse file", filepath)
                file_module.append(scan_file(filepath, headers))
            except Exception as e:
                print("Error: Parse file", filepath, "error.")
                print(e)
                continue
    else:
        p = Pool(args.parallel)
        file_module = p.starmap(scan_file_helper, 
                zip(srcs, repeat(headers)))
    # print(file_module)
    module_file = dict()
    module_hier = dict()
    for vfile, vmods in file_module:
        for vmod, insts in vmods.items():
            module_file[vmod] = vfile
            module_hier[vmod] = insts
    # print(module_file)
    # print(module_hier)
    return file_module, module_file, module_hier


def solve_dep(top, file_module, module_file, module_hier):
    all_modules = set(module_file.keys())
    # print(all_modules)
    # print(module_hier)
    module_nfd = []
    module_used = set([top])
    module_deq = deque([top]) 
    while (module_deq):
        now = module_deq.popleft()
        for m in module_hier[now]:
            if m in all_modules:
                if m not in module_used:
                    module_used.add(m)
                    module_deq.append(m)
            else:
                module_nfd.append((m, module_file[now]))
    module_unused = set([m for m in all_modules if not m in module_used])
    file_unused = set()
    for vfile, vmods in file_module:
        fun = True
        for vmod in vmods:
            if not vmod in module_unused:
                fun = False
                break
        if fun:
            file_unused.add(vfile)
    return module_nfd, file_unused


def act(args, module_not_found, file_unused):
    for m, f in module_not_found:
        print("Module", m, "not found. Referenced in file", f)
    for f in file_unused:
        print("File", f, "unused.")
        if args.delete:
            os.remove(f)
            print("Deleted.")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('dir', type=str)
    parser.add_argument('-d', '--delete', action='store_true')
    parser.add_argument('-j', '--parallel', type=int, default=1)
    parser.add_argument('-t', '--top', default='NV_nvdla')
    args = parser.parse_args()
    fm, mf, mh = scan_folder(args.dir, args)
    top = args.top
    m_nfd, f_un = solve_dep(top, fm, mf, mh)
    act(args, m_nfd, f_un)

def test():
    # scan_folder("top")
    # scan_folder("../../nvdla_vmod")
    fm, mf, mh = scan_folder("top")
    mnfd, munud = solve_dep("NV_nvdla", fm, mf, mh)
    print(mnfd)
    print(munud)

if __name__ == "__main__":
    main()
    # test()

