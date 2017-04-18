require 'xcodeproj'

class DroiCoreParser

	# find all of xcodeproj file
	def self.installParser()
		Dir.glob('*.xcodeproj') do |file_name|
			next if file_name == '.' or file_name == '..'
			
  			DroiCoreParser.addBuildPhase( file_name )
		end
	end

	# Add new build pahse into xcodeproject file
	def self.addBuildPhase( xcodeprojfile )
		project = Xcodeproj::Project.open(xcodeprojfile)
		main_target = project.targets.first
		$index = -1
		phases = main_target.shell_script_build_phases 
		for $i in 0..phases.size 
			p = phases.at($i)
			if p != nil && p.name == "DroiBaaS Preprocessor"
				phase = p
				$index = $i
				break
			end
		end

		has_swift = 0
		has_objc = 0
        main_target.source_build_phase.files.each do |build_file|
	        full_path = build_file.file_ref.real_path
	        if full_path.extname == '.swift'
	        	has_swift = 1
	        elsif full_path.extname == '.m' || full_path.extname == '.mm'
	        	has_objc = 1
	        end
        end

        unless $index == -1
				main_target.build_phases.delete( phase )        	
        end

		
		# Create new build phase
		phase = main_target.new_shell_script_build_phase("DroiBaaS Preprocessor") if $index == -1
		phase.shell_script = '"${PODS_ROOT}/DroiCoreSDK/scripts/baas_cli" parse "${SRCROOT}"' 
		main_target.build_phases.delete( phase )
		main_target.build_phases.insert( 0, phase )


		# Find a root folder in the users Xcode Project called Pods, or make one
		# Insert source files
		# Copy template into source path
		root_group = project.main_group.groups[0]
		real_path = root_group.real_path.to_s
		droi_group = root_group["DroiBaaS"]
		unless droi_group
  			droi_group = root_group.new_group("DroiBaaS")

    		file_refs = []
    		res_refs = []
    		if has_objc == 1
				file_refs << droi_group.new_file('DroiBaaS.h')
				file_refs << droi_group.new_file('DroiBaaS.m')
			end

			if has_swift == 1
				file_refs << droi_group.new_file('DroiBaaSForSwift.swift')
			end

			res_refs << droi_group.new_file('DroiBaaS.plist')
			main_target.add_file_references(file_refs)
			main_target.add_resources(res_refs)
		end

		if has_objc == 1
			FileUtils.cp "./Pods/DroiCoreSDK/sources/DroiBaaS.h", real_path + '/DroiBaaS.h'
			FileUtils.cp "./Pods/DroiCoreSDK/sources/DroiBaaS.m", real_path + '/DroiBaaS.m'
		end

		if has_swift == 1
			FileUtils.cp "./Pods/DroiCoreSDK/sources/DroiBaaSForSwift.swift", real_path + '/DroiBaaSForSwift.swift'
		end
		FileUtils.cp "./Pods/DroiCoreSDK/sources/DroiBaaS.plist", real_path + '/DroiBaaS.plist'

		project.save()
		puts 'new build phase'
	end

end

#DroiCoreParser.installParser()

