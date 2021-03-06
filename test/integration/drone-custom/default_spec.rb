describe file('/var/lib/drone/drone.sqlite') do
  it { should be_file }
end

# nginx
describe port(80) do
  it { should be_listening }
end
describe port(443) do
  it { should be_listening }
end
describe file('/etc/nginx/sites-available/default') do
  its(:content) { should match(/proxy_set_header Upgrade \$http_upgrade;/) }
  its(:content) { should match(/proxy_set_header Connection "upgrade"/) }
end

# drone
describe port(8000) do
  it { should be_listening }
end

# Ubuntu image doesn't doesn't have cURL by default but wget can be used.
describe command("wget -q --no-check-certificate https://localhost") do
  its(:exit_status) { should eq 0 }
end

# Agent connects
describe command("docker logs agent") do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should eq '' }
  its(:stderr) { should eq '' }
end
describe command("docker logs drone") do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should include('level=debug msg="Agent 172.17.0.1 connected."') }
end
