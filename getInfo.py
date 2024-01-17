from os import listdir
from platform import uname
from psutil import win_service_iter
import socket

def ip_address():
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.connect(("8.8.8.8", 80))
    ip = s.getsockname()[0]
    s.close()
    return ip

def names():
    sys_info = uname()
    return sys_info.node, sys_info.system + ' ' + sys_info.version, sys_info.machine
    
def services():
    default = set()
    services = win_service_iter()
    service_names = [service.display_name() for service in services if service.start_type() == 'automatic']
    service_names = set(service_names)
    service_names = service_names - default
    return (sorted(service_names))

def software():
    default = set(['Common Files', 'Internet Explorer', 'MSBuild', 'Reference Assemblies', 'Windows Defender', 'Windows Mail', 'Windows Media Player', 'Windows NT', 'Windows Photo Viewer', 'Windows Portable Devices', 'Windows Sidebar'])
    programs = listdir(path='C:\Program Files')
    programs += listdir(path='C:\Program Files (x86)')
    programs = set(programs)
    programs = programs - default
    return sorted(programs)

def write_file(box_name, ip, OS_version, architecture, service_names, programs):
    with open(box_name + "_info.txt", "w") as f:
        f.write("Name\n")
        f.write("\t" + box_name + "\n")
        f.write("IP\n") 
        f.write("\t" + ip + "\n")
        f.write("Version\n")
        f.write("\t" + OS_version + "\n")
        f.write("Architecture\n")
        f.write("\t" + architecture + "\n")
        f.write("Services\n")
        for service in service_names:
            f.write("\t" + service + "\n")
        f.write("Programs\n")
        for program in programs:
            f.write("\t" + program + "\n")

def main():
    box_name, OS_version, architecture = names()
    programs = software()
    service_names = services()
    ip = ip_address()

    write_file(box_name, ip, OS_version, architecture, service_names, programs)

if __name__ == '__main__':
    main()