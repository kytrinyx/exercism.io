module X
  module Docs
    class CLI
      %w(troubleshooting linux mac windows).each do |topic|
        define_method topic do
          read topic
        end
      end

      private

      def read(topic)
        File.read("./x/docs/md/cli/#{topic}.md")
      end
    end
  end
end
