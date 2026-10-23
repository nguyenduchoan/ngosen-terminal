// SPDX-License-Identifier: GPL-3.0-or-later
#include "ngosen-engine.h"
#include "ngosen-fcitx-host.h"
#include "test-input-context.h"

int main() {
    configureTestPaths("fcitx5-ngosen-terminal-reset-commit");
    TestInstance        test;
    fcitx::NgoSenEngine engine(&test.instance);
    fcitx::RawConfig    config;
    config.setValueByPath("Mode", "Sen");
    config.setValueByPath("InputMethod", "Telex");
    engine.setConfig(config);
    TestInputContext context(&test.instance, "code", "dbus");
    context.setCapabilityFlags(fcitx::CapabilityFlag::KeyEventOrderFix);
    context.focusIn();
    ngosen::FcitxHost host(&context, &test.instance);
    host.commitText("ếng");
    if (context.commits() != std::vector<std::string>{"ế", "n", "g"}) {
        std::cerr << "Terminal replacement must arrive as individual characters\n";
        return 1;
    }
    for (const auto* program : {"", "code", "code.desktop"}) {
        TestInputContext wayland(&test.instance, program, "ibus");
        wayland.setCapabilityFlags(fcitx::CapabilityFlag::Preedit);
        ngosen::FcitxHost waylandHost(&wayland, &test.instance);
        waylandHost.commitText("ất ");
        // GNOME sends one text-input done; the client keeps the last commit before it.
        if (wayland.commits().back() != "ất ") {
            std::cerr << "GNOME replacement lost characters before text-input done\n";
            return 1;
        }
    }
    fcitx::InputMethodEntry  entry("ngosen", "Ngó Sen", "vi", "ngosen");
    fcitx::InputContextEvent focus(&context, fcitx::EventType::InputContextFocusIn);
    engine.activate(entry, focus);
    fcitx::KeyEvent first(&context, fcitx::Key(FcitxKey_d), false);
    engine.keyEvent(entry, first);
    fcitx::InputContextEvent reset(&context, fcitx::EventType::InputContextReset);
    engine.reset(entry, reset);
    fcitx::KeyEvent second(&context, fcitx::Key(FcitxKey_d), false);
    engine.keyEvent(entry, second);
    if (second.accepted()) {
        std::cerr << "New terminal inherited the previous terminal's d\n";
        return 1;
    }
    return 0;
}
