#
# Cookbook Name:: proftpd
# Recipe:: default
#
package "net-ftp/proftpd" do
  action :install
end

remote_file "/etc/proftpd/proftpd.conf" do
  owner "root"
  group "root"
  mode 0755
  source "proftpd.conf"
  action :create
end

directory "/home/ftp/uploads" do
  owner "ftp"
  group "ftp"
  mode 0755
end

execute "add-proftpd-to-default-run-level" do
  command %Q{
    rc-update add proftpd default
  }
  not_if "rc-status | grep proftpd"
end

execute "ensure-proftpd-is-running" do
  command %Q{
    /etc/init.d/proftpd restart
  }
  not_if "/etc/init.d/proftpd status | grep 'status:  started'"
end