require "lf/roles/version"

module Lf
  module Roles
    def roles=(roles)
      self.roles_mask = (roles & self.class.possible_roles).map { |r| 2**self.class.possible_roles.index(r) }.inject(0, :+)
    end

    def roles
      self.class.possible_roles.reject do |r|
        ((roles_mask.to_i || 0) & 2**self.class.possible_roles.index(r)).zero?
      end
    end

    def is?(role)
      roles.include?(role.to_s.downcase)
    end

    def is_any?(*check_roles)
      !(roles & check_roles).empty?
    end

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def by_role(role)
        role_id = 2**@possible_roles.index(role)
        mask_array = []
        mask_array.push(role_id)
        total = 2**@possible_roles.count
        (role_id+1..total-1).each do |i|
          val = i
          val -= role_id
          power = 0
          until power == role_id || val < 1
            power = nearest_power?(val)
            val -= power
          end
          if val == 0 && power != role_id
           mask_array.push(i)
          end
        end
        users = self.where(roles_mask: mask_array)
      end

      def possible_roles
        @possible_roles
      end

      private
        def nearest_power?(val)
          n = 0
          while val >= 2
            val = val/2
            n += 1
          end
          2**n
        end

        def setup_roles
          @possible_roles = [] unless @possible_roles
        end

        def add_possible_roles(*roles)
          roles.each {|role| possible_role role}
        end

        def possible_role(role)
          setup_roles
          @possible_roles << role.downcase unless @possible_roles.include?(role)
        end
    end
  end
end
