#migration_helpers.rb
module MigrationHelpers

  def add_foreign_key(from_table, from_column, to_table, name = nil )
    constraint_name = ""
    if name != nil
      constraint_name = name
    else
      constraint_name = "fk_#{from_table}_#{from_column}"
    end
    execute %{alter table #{from_table}
              add constraint #{constraint_name}
              foreign key (#{from_column})
              references #{to_table}(id)}
  end


  def remove_foreign_key(from_table, from_column, name = nil )
    constraint_name = ""
    if name != nil
      constraint_name = name
    else
      constraint_name = "fk_#{from_table}_#{from_column}"
    end

    execute %{alter table #{from_table}
             drop foreign key #{constraint_name}}
  end

end

