import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_note/presentation/components/navigate.dart';
import '../../business_logic/note_bloc/note_cubit.dart';
import '../../business_logic/note_bloc/note_states.dart';
import '../../constants/colors.dart';
import '../components/default_form_field.dart';
import 'add_note_screen.dart';


class HomeScreen extends StatelessWidget {
   HomeScreen({Key? key}) : super(key: key);

  final _scaffoldKey=GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    NoteCubit noteCubit=BlocProvider.of<NoteCubit>(context);
    return BlocConsumer<NoteCubit,NoteState>(
      listener:(context,state){},
      builder: (context,state){
        return  LayoutBuilder(
          builder:(context,constraints)=> Scaffold(
            key:_scaffoldKey,
            appBar:AppBar(
              leadingWidth:constraints.maxWidth*0.22,
              leading:Padding(
                padding: EdgeInsets.only( left:constraints.maxWidth*0.060,),
                ///because the main appbar has more components than other appbars ,so it would be more complicated
                ///if i did not make these conditions

                /// this first condition here because the appbars don't have a leading except the main one

                child:noteCubit.currentIndex==0? Image.asset('assets/icons/appbar_icon.png',
                  fit: BoxFit.fitHeight,
                ):null,
              ),
              centerTitle:noteCubit.currentIndex==0?false:true,
              title:Transform.translate(
                offset:Offset(-constraints.maxWidth*0.024, 0),
                child: Text(noteCubit.notesAppBar[noteCubit.currentIndex].title,style:const TextStyle(
                  fontSize:25,
                  fontWeight: FontWeight.w500,
                ),),
              ),
              actions:noteCubit.currentIndex==0?[
                IconButton(
                icon: Icon(noteCubit.isSearch?Icons.close:Icons.search),
                onPressed: ()
                {
                  noteCubit.changeHomeBar();
                },
              ),
              ]:
              noteCubit.notesAppBar[noteCubit.currentIndex].actions,
              bottom: PreferredSize(
                preferredSize:Size.fromHeight(noteCubit.isSearch?constraints.maxHeight*0.09:constraints.maxHeight*0.1/3),
                child:noteCubit.isSearch? HomeSearchBar():Container(),
              ),
            ),

            backgroundColor: defaultWhite,
            resizeToAvoidBottomInset: false,

            floatingActionButton:FloatingActionButton(
              splashColor:Colors.blue,
              child:Icon(Icons.add,color:defaultColor,),
              onPressed:()
              {
                navigateTo(context,AddNoteScreen(title:'',body: '',));
              },
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

            bottomNavigationBar: ClipRRect(
              borderRadius:const BorderRadius.only(topLeft:Radius.circular(17),topRight: Radius.circular(17),),
              child: SizedBox(
              height:constraints.maxHeight*0.10,
              width: double.infinity,
              child: BottomNavigationBar(
                onTap:(index){
                  noteCubit.navigationBarChange(index);
                } ,
                selectedLabelStyle:const TextStyle(
                  color: Colors.white,
                ),
                currentIndex:noteCubit.currentIndex,
                items:const [
                  BottomNavigationBarItem(icon:Icon(Icons.home),label:"Home"),
                  BottomNavigationBarItem(icon:Icon(Icons.favorite),label:"Favorites"),
                ],
              )
                ),
            ),

            body:Stack(
              alignment: Alignment.bottomCenter,
              children:[
                noteCubit.screens[noteCubit.currentIndex],
             ],
            ),
          ),
        );
      },
    );
  }
}



class HomeSearchBar extends StatelessWidget {
    HomeSearchBar({Key? key}) : super(key: key);

    final TextEditingController _searchController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:const EdgeInsets.all(8.0),
      child: DefaultFormField(
        controller:_searchController,
        border:InputBorder.none,
        cursorHeight:22,
        hintText:'Enter the note title',
        hintStyle:const TextStyle(
          fontSize: 18,
        ),
        prefixIcon:const Icon(Icons.search_rounded),
        contentPadding:const EdgeInsets.symmetric(vertical:18),
        cursorColor:defaultColor,
        maxLines: 1,
        onFieldSubmitted:(value)
        {
          BlocProvider.of<NoteCubit>(context).search(value);
        },
        onChanged: (value)
        {
             BlocProvider.of<NoteCubit>(context).search(value);
        },
      ),
    );
  }
}
