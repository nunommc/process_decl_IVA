# frozen_string_literal: true

require_relative "lib/process_decl_iva/version"

Gem::Specification.new do |spec|
  spec.name = "process_decl_IVA"
  spec.version = ProcessDeclIva::VERSION
  spec.authors = ["Nuno Costa"]
  spec.email = ["nuno.mmc@gmail.com"]

  spec.summary = "Script para auxiliar no preenchimento da Declaração periódica do IVA"
  spec.description = 'Processa o CSV do mapa de reservas exportado da Talkguest e o CSV exportado do e-fatura
    para um dado trimestre, e demonstra que valores têm que ser preenchidos na declaração periódica do IVA'
  spec.homepage = "https://process-decl-IVA.github.io"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end
  spec.bindir = "bin"
  spec.executables = ["process_decl_iva"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "standardrb"
  spec.add_development_dependency "rake", "~> 11.3.0"
end
