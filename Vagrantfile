Vagrant::Config.run do |config|
	config.vm.define :jenkins do |config|
		config.vm.box = "lucid64"
		config.vm.box_url = "http://files.vagrantup.com/lucid64.box"
		config.vm.boot_mode = :gui
		config.vm.provision :shell, :inline => "sudo apt-get update"
		config.vm.forward_port "jenkins", 8080, 8081
		
		config.vm.provision :puppet do |puppet|
		 puppet.manifests_path = "manifests"
		 puppet.manifest_file  = "jenkins.pp"
		end
				
		config.vm.share_folder "./jenkins/home/", "/var/lib/jenkins/jobs", "jenkins/home/"
	end
end
