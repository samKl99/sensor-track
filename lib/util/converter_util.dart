class ConverterUtil {
  static double fromPaToHPa(final int pa) {
    if (pa == 0) {
      return 0;
    } else {
      return pa / 100;
    }
  }
}
