local php_settings = require("config.php-settings")

return {
	root_markers = { "composer.json", ".git", "wp-config.php" },
	settings = php_settings.getPhpSettings(),
}
