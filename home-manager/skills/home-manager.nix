{
  emilkowalski-skills,
  interfaces-skills,
  modern-web-guidance,
  mattpocock-skills,
  playwright-cli-skills,
  wshobson-agents,
}:
{
  programs.agent-skills = {
    enable = true;
    sources = {
      emilkowalski = {
        path = emilkowalski-skills;
        subdir = "skills";
        idPrefix = "emilkowalski";
      };
      interfaces = {
        path = interfaces-skills;
        subdir = "skills";
      };
      google-chrome = {
        path = modern-web-guidance;
        subdir = "skills";
        idPrefix = "google-chrome";
      };
      mattpocock = {
        path = mattpocock-skills;
        subdir = "skills/productivity";
        idPrefix = "mattpocock";
      };
      playwright = {
        path = playwright-cli-skills;
        subdir = "skills";
        idPrefix = "playwright";
      };
      wshobson = {
        path = wshobson-agents;
        subdir = "plugins/ui-design/skills";
        idPrefix = "wshobson";
      };
    };
    skills = {
      enableAll = [
        "emilkowalski"
        "interfaces"
      ];
      explicit = {
        grill-me = {
          from = "mattpocock";
          path = "grill-me";
        };
        modern-web-guidance = {
          from = "google-chrome";
          path = "modern-web-guidance";
        };
        playwright-cli = {
          from = "playwright";
          path = "playwright-cli";
        };
        web-component-design = {
          from = "wshobson";
          path = "web-component-design";
        };
      };
    };
    targets.agents.enable = true;
  };

  home.sessionVariables.DISABLE_TELEMETRY = "1";
}
