// scripts/GradeColor/scr_grade_color.gml
function scr_grade_color(_rank) {
    switch (_rank) {
        case "S+": case "S":            return make_color_rgb(190, 150, 0);
		case "A":                       return make_color_rgb(30, 150, 30);
		case "B":                       return make_color_rgb(40, 120, 210);
		case "C":                       return make_color_rgb(120, 120, 120);
		case "D+": case "D": case "D-": return make_color_rgb(210, 110, 0);
		case "F+": case "F": case "F-": return make_color_rgb(210, 40, 40);
        default:                        return make_color_rgb(35, 35, 35);
    }
}