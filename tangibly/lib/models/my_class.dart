enum EClassStat {
  TODO,
  POSTPONDED,
  INPROGRESS,
  DONE
}

extension ParseToString on EClassStat {
  String toShortString() {
    return this.toString().split('.').last;
  }

  // 모든 배열 String으로 나열.
  List<String> listAll() {
    List<String> res= [];
    for(var value in EClassStat.values) {
      res.add(value.toShortString().toLowerCase());
    }
    return res;
  }

  // 어떤 순서의 스테이터스인지
  int parseWhichStatus() {
    for(int i=0; i<EClassStat.values.length; ++i) {
      if(EClassStat.values[i] == this)
        return i;
    }
    return 0;
  }

}

class MyClass {
  final String title;
  final String assignedTeacher;
  final String assignedStudent;
  //final EClassStat eEventStatus;
  final EClassStat eventStatus;
  final DateTime dateTime;
  const MyClass(this.title, this.assignedTeacher, this.assignedStudent, this.eventStatus, this.dateTime, );

  @override
  String toString() => title;
}