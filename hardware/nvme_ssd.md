# NVMe SSD special setup for Ubuntu

## Installing on a Dell laptop with a NVMe M.2 SSD

[Dell Support](https://www.dell.com/support/article/en-al/sln308883/how-to-resolve-an-pcie-nvme-m-2-ssd-ubuntu-kubuntu-installation-problem-on-your-dell-pc?lang=en)

Make sure that AHCI is enabled instead of RAID in the BIOS

## Filesystem remounted as read-only when resuming from suspend

[Launchpad](https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1655100)
[ArchLinux](https://bbs.archlinux.org/viewtopic.php?id=216520)
[Stack Overflow](https://askubuntu.com/a/981658/512517)
[Kernel Bugzilla](https://bugzilla.kernel.org/show_bug.cgi?id=112121)

Add the following options to `GRUB_CMDLINE_LINUX_DEFAULT` in `/etc/default/grub`

- `acpiphp.disable=1`
- `pcie_aspm=off`

So it looks something like this:

`GRUB_CMDLINE_LINUX_DEFAULT="quiet splash acpiphp.disable=1 pcie_aspm=off"`

It also appears that there is a [patch](https://patchwork.kernel.org/patch/10212201/) for the kernel for this as well, but I'm not ready to compile my kernel from source.
