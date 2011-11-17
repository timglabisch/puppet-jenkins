exec { "add_apt_key":
	path => ["/bin", "/usr/bin"],
	command => "wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -",
}

exec { "add_deb":
	path => ["/bin", "/usr/bin"],
	command => "sudo sh -c 'echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'",
	require => Exec["add_apt_key"]
}

exec { "update_sources":
	path => ["/bin", "/usr/bin"],
	command => "sudo apt-get update",
	require => Exec["add_deb"]
}

package { ['jenkins']:
    ensure => installed,
	require => Exec["update_sources"]
}

service { "jenkins":
	enable => true,
	ensure => running,
	require => [Package["jenkins"], File["/var/lib/jenkins/plugins"]]
}

file { "/var/lib/jenkins/plugins": 
	ensure => "directory",
	owner => "root",
	group => "root",
	mode => 0777,
}

exec { "plugin_git":
	path => ["/bin", "/usr/bin"],
	cwd => '/var/lib/jenkins/plugins',
	command => "wget --no-check-certificate http://updates.jenkins-ci.org/latest/git.hpi",
	require => Service["jenkins"]
}

exec { "plugin_build-pipeline-plugin":
	path => ["/bin", "/usr/bin"],
	cwd => '/var/lib/jenkins/plugins',
	command => "wget --no-check-certificate http://updates.jenkins-ci.org/latest/build-pipeline-plugin.hpi",
	require => Service["jenkins"]
}

exec { "plugin_mercurial":
	path => ["/bin", "/usr/bin"],
	cwd => '/var/lib/jenkins/plugins',
	command => "wget --no-check-certificate http://updates.jenkins-ci.org/latest/mercurial.hpi",
	require => Service["jenkins"]
}

exec { "plugin_multiple-scms":
	path => ["/bin", "/usr/bin"],
	cwd => '/var/lib/jenkins/plugins',
	command => "wget --no-check-certificate http://updates.jenkins-ci.org/latest/multiple-scms.hpi",
	require => Service["jenkins"]
}

exec { "restart_jenkins":
	path => ["/bin", "/usr/bin", "/var/lib/jenkins"],
	cwd => "/var/lib/jenkins/jobs",
	command => "java -jar jenkins-cli.jar -s http://127.0.0.1:8080 restart",
	require => Exec["plugin_git", "plugin_build-pipeline-plugin", "plugin_mercurial", "plugin_multiple-scms"]
}
