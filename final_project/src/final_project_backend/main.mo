// importlar
import Map "mo:base/HashMap";
import Text "mo:base/Text";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Hash "mo:base/Hash";

actor Assistant {
  type ToDo = {
    description: Text;
    completed: Bool;
  };

  func natHash(n: Nat) : Hash.Hash {
    Text.hash(Nat.toText(n))
  };

  var todos = Map.HashMap<Nat, ToDo>(0, Nat.equal, natHash);
  var nextId: Nat = 0;
  var task_size: Nat = 0;
  var accumulatedPoints: Nat = 0;
  var pointsForTree: Nat = 0;
  var treeCount : Nat = 0;


  public query func getTodos() : async [ToDo] {
    Iter.toArray(todos.vals());
  };


  public func taskSize (size: Nat) : async () {
    task_size := size;
  };


  public func addTodo (description: Text) : async Nat {
    let id = nextId;
    todos.put(id, {description=description; completed = false});
    nextId += 1;
    id // return id;
  };

  public func completeTodo(id: Nat) : async Text {
    task_size -= 1;   // Every time we completed a task, we decrement the task size.
    var output : Text = "Remaining tasks: " # Nat.toText(task_size);
    
    if(task_size == 0) {
      output #= "\nCongrats! You finished all of your tasks today!";
      output #= "\nYou got 25 extra points!";
      accumulatedPoints += 25;
      };
    accumulatedPoints += 50;    // Every time we completed a task, 50 points are added to the total points.
    ignore do ? {
      let description = todos.get(id)!.description;
      todos.put(id, {description; completed = true});
    };
    if(accumulatedPoints >= 200) {
      accumulatedPoints := accumulatedPoints%200;   // If we collected more than 200 points, we will continue with remaining points.
      pointsForTree += 20;    // for each 200 points we collected, we will get 20 points for tree acount.
    };

    output
  };



  public query func pointsAccount () : async Text {   // for every 100 tree points, one tree will be planted.
    var output : Text = "\nAccumulated points from the tasks:" # Nat.toText(accumulatedPoints);
    output #= "\nCurrent tree points: " # Nat.toText(pointsForTree);
    if(pointsForTree >= 100) {
        output #= "\nCongrats! You reached 1000 points and earned a chance to plant one tree!";
        pointsForTree -= pointsForTree%1000;
        output #= "\n🌳 One tree will be planted in Atatürk Orman Çiftliği.\nYou can check your tree in the given location: AOÇ 🌳";
    };
    output #= "\nWith your hard work, the number of trees planted so far: " # Nat.toText(treeCount);

    if(treeCount == 0) output #= "\nYour status: level 1"
    else if (treeCount < 4) output #= "\nYour status: level 2"
    else if (treeCount < 8) output #= "\nYour status: level 3"
    else output #= "\nYour status: level 4";
    output # "\n"
  };


  public query func showTodos (): async Text {
    var output: Text = "\n_______TO-DOs_______";
    for (todo: ToDo in todos.vals()) {
      output #= "\n" # todo.description;
      if(todo.completed) { output #= " +" };
    };
    output # "\n";
  };


  public func clearCompleted() : async () {
    todos := Map.mapFilter<Nat, ToDo, ToDo>(todos, Nat.equal, natHash,
    func(_, todo) {if(todo.completed) null else ?todo});
  };

  
};