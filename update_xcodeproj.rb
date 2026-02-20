require 'xcodeproj'
project_path = '/Users/raphaelodeareduo/Desktop/my_stuff/SnapChef/SnapChef.xcodeproj'
project = Xcodeproj::Project.open(project_path)
target = project.targets.first
group = project.main_group.find_subpath(File.join('SnapChef'), false)

['Recipe.swift', 'IngredientScan.swift', 'UserSettings.swift'].each do |file_name|
  file_ref = group.new_reference(file_name)
  target.add_file_references([file_ref])
end

item_ref = group.files.find { |f| f.path == 'Item.swift' }
if item_ref
  target.source_build_phase.files_references.delete(item_ref)
  item_ref.remove_from_project
end

project.save
