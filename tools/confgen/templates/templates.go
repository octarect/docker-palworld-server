package templates

import (
	_ "embed"
	"fmt"
	"text/template"

	"github.com/Masterminds/sprig/v3"
)

var (
	//go:embed PalWorldSettings.ini.tmpl
	palWorldSettings []byte
)

func expr(lhs, rhs string) string {
	return fmt.Sprintf("%s=%s", lhs, rhs)
}

func LoadTemplate(target string) (tmpl *template.Template, err error) {
	var bs []byte
	switch target {
	case "PalWorldSettings.ini":
		bs = palWorldSettings
	default:
		err = fmt.Errorf("Unknown target specified. target=%s", target)
		return
	}

	tmpl = template.New("tmpl")

	// import useful functions into template.
	tmpl.Funcs(sprig.FuncMap())

	// custom functions
	tmpl.Funcs(template.FuncMap{
		"expr": expr,
	})

	if _, err := tmpl.Parse(string(bs)); err != nil {
		return nil, err
	}

	return
}
