from platform import uname
import socket

if (uname().system == 'Windows'):
    from winreg import ConnectRegistry, HKEY_LOCAL_MACHINE, OpenKey, QueryInfoKey, EnumKey, QueryValueEx
    from os import listdir
    import psutil
else:
    import apt

def ip_address():
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.connect(("138.247.254.1", 80))
    ip = s.getsockname()[0]
    s.close()
    return ip

def names():
    sys_info = uname()
    return sys_info.node, sys_info.system + ' ' + sys_info.version, sys_info.machine
    
def win_services():
    default = set()
    services = psutil.win_service_iter()
    service_names = [service.display_name() for service in services if service.start_type() == 'automatic']
    service_names = set(service_names)
    service_names = service_names - default
    return (sorted(service_names))

def win_software():
    programs = []
    reg = ConnectRegistry(None, HKEY_LOCAL_MACHINE)
    key = OpenKey(reg, r"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall")

    for i in range(QueryInfoKey(key)[0]):
        software_key_name = EnumKey(key, i)
        software_key = OpenKey(key, software_key_name)
        try:
            software_version = QueryValueEx(software_key, "DisplayVersion")[0]
            if (software_key_name[0] != '{' and software_key_name[0]):
                if (software_version in software_key_name):
                    software_key_name = software_key_name[:software_key_name.find(software_version)]
                    if (software_key_name != ''):
                        programs += [software_key_name + ' | ' + software_version]
        except Exception as e:
            pass
    return programs

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

def lin_software():

    cache = apt.Cache()

    for mypkg in cache:
        if cache[mypkg.name].is_installed:
            print(mypkg.name)

def lin_services():
    return "Linux Bad"

def main():
    box_name, OS_version, architecture = names()
    ip = ip_address()
    if (OS_version.split(' ')[0] == 'Windows'):
        programs = win_software()
        service_names = win_services()
    else:
        programs = lin_software()
        service_names = lin_services()

    write_file(box_name, ip, OS_version, architecture, service_names, programs)

if __name__ == '__main__':
    main()